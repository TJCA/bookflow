class SessionsController < ApplicationController
  def new
    if session[:current_user_id]
      redirect_to profile_url
    end
  end

  def create
    login_info = params[:login_info]
    case User.check(login_info[:school_id], login_info[:password])
      when :not_exist
        redirect_to root_url, flash: { error: "用户不存在" }
      when :unmatch
        redirect_to login_url, flash: { error: "密码错误" }
      when :empty_pwd
        session[:current_user_id] = login_info[:school_id]
        redirect_to profile_url, flash: { warning: "请尽快修改密码" }
      when :success
        session[:current_user_id] = login_info[:school_id]
        redirect_to profile_url
      else
        redirect_to login_url, flash: { error: "未知错误" }
    end
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  def reset_password
  end

  def message_login
    if params[:verify_number] == session[:verification_id].to_s
      session[:verification_id] = nil
      session[:current_user_id] = session[:school_id_in_queue]
      session[:school_id_in_queue] = nil
      redirect_to profile_url, flash: { info: "请到个人信息界面修改密码" }
    else
      redirect_to reset_url, flash: { error: "短信验证码错误" }
    end
  end
end
