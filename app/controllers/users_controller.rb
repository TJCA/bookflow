class UsersController < ApplicationController
  load_and_authorize_resource
  
  def new
    if session[:current_user_id]
      redirect_to profile_url
    end
  end
  
  def create
    # here we need to check by phone
    if params[:verify_code] != session[:verification_id].to_s
      redirect_to new_user_url, :flash => { error: "验证码错误" }
      # cancel it?
    elsif User.register user_params
      #if User.create(user_params).valid?
      session[:verification_id] = nil
      session[:current_user_id] = user_params[:school_id]
      redirect_to profile_url, :flash => { success: "注册成功" }
    else
      redirect_to register_url, :flash => { error: "资料有误" }
    end
  end
  
  def show
    if session[:current_user_id]
      @user = User.find_by school_id: params[:user_id]
    else
      redirect_to login_url, flash: { error: "请先登录" }
    end
  end

  def info
    @info = current_user.personal_information
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update!(fullname: user_params[:fullname],
                            email: user_params[:email],
                        grad_year: user_params[:grad_year])
      current_user.save
      redirect_to profile_url, flash: { success: "修改用户信息成功" }
    else
      redirect_to me_information_url, flash: { error: "用户信息修改失败" }
    end
  end

  def change_password
  end

  def verify
    if User.find_by phone: params[:phone]
      render status: :conflict
      render json: { status: "used" }
    else
      verify_id = rand(100000..999999)
      session[:verification_id] = verify_id
      Alidayu::Sms.send_code_for_sign_up(params[:phone], { code: verify_id.to_s }, '')
      render json: { status: "ok" }
    end
  end

  def write_password
    case User.change_password(current_user, params[:password])
      when :success
        redirect_to profile_url, flash: { success: "密码修改成功" }
      when :too_short
        redirect_to me_password_edit_url, flash: { error: "密码不能短于6位" }
      else
        redirect_to profile_url, flash: { error: "未知错误" }
    end
  end

  def set_admin
    if params[:type] == 'enpower'
      status = User.add_admin params[:sid]
    elsif params[:type] == 'depower'
      status = User.delete_admin params[:sid]
    else
      status = 'bad parameters'
    end
    render json: { status: status }
  end

  def enpower
    if params[:q].nil?
      @admins = User.where "role >= ?", 0b0010
    else
      @admins = User.where school_id: params[:q]
    end
  end

  def ask_code
    user = User.find_by_school_id params[:sid]
    if user.nil?
      render json: { status: 'no such user' }
    else
      verify_id = rand(100000..999999)
      session[:verification_id] = verify_id
      session[:school_id_in_queue] = params[:sid]
      Alidayu::Sms.send_code_for_msg_login(user.phone, { sid: params[:sid], code: verify_id.to_s }, '')
      render json: { status: 'ok' }
    end
  end

  def statistics
    launch_day = Time.parse("2016-09-06 21:56")
    @all_users = User.count
    @all_books = Book.count
    @registrations_after_launch = User.where("created_at > ?", launch_day).count
  end

  def show_info
    @user = User.where(school_id: params[:school_id]).take
    if @user.nil?
      render status: :not_found
    else
      render :show_info
    end
  end
  
  private
    def user_params
      params[:verified] = true
      params.require(:user).permit(:fullname, :school_id, :phone, :email,
                                   :password, :grad_year, :verified)
    end 
end
