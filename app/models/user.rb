class User < ActiveRecord::Base
  has_many :records
  has_many :appointments

  validates :phone, on: :create, format: {
    with: /1[3578]\d{9}/,
    message: "必须是中国大陆的正确手机号"
  }
  validates :phone, :school_id, on: :create, uniqueness: true
  # TODO: other item should also be considered
  validates :fullname, presence: true
  validates :password, on: :create, length: {
    minimum: 6,
    too_short: "密码至少六位"
  }
  validates :email, uniqueness: true
  validates :phone, :school_id, on: :create, presence: true

  def has_role?(role)
    # IN RUBY 0 WILL BE SEEN AS TRUE !!!
    case role
    when :super_admin
      (self.role & 0b1000) != 0
    when :admin
      (self.role & 0b0100) != 0
    when :operator
      (self.role & 0b0010) != 0
    when :ordinary_user
      (self.role & 0b0001) != 0
    else
      false
    end
  end

  def personal_information
    {
      name: self.fullname,
      email: self.email,
      phone: self.phone,
      graduation: self.grad_year,
      school_id: self.school_id,
      credit: self.credit,
      status:
        if self.has_role? :super_admin
          "超级管理员"
        elsif self.has_role? :admin
          "管理员"
        elsif self.has_role? :operator
          "普通操作员"
        elsif self.has_role? :ordinary_user
          "正常用户"
        else
          "冻结用户"
        end
    }
  end

  def self.check(user, pwd)
    this_user = self.find_by school_id: user
    if this_user.nil?
      :not_exist
    elsif this_user.password.nil? or this_user.password.empty?
      this_user.phone.index(pwd, 5)
      :empty_pwd
    elsif this_user.password == salt_pwd(pwd)
      :success
    else
      :unmatch
    end
  end

  def self.register(params)
    params[:password] = salt_pwd(params[:password])
    params[:credit] = 40
    self.create(params).valid?
  end

  def self.change_password(user, password)
    if password.length < 6
      :too_short
    else
      user.password = salt_pwd(password)
      user.save
      :success
    end
  end

  def self.add_admin(school_id)
    user = self.find_by_school_id school_id
    if user.nil?
      'not found'
    else
      if user.role & 0b1110 != 0
        'already in admin'
      else
        user.role = 0b0011
        user.save
        'ok'
      end
    end
  end

  def self.delete_admin(school_id)
    user = self.find_by_school_id school_id
    if user.nil?
      'not found'
    else
      if user.role & 0b1110 != 0
        user.role = 0b0001
        user.save
        'ok'
      else
        'not admin before'
      end
    end
  end

  private
    def self.salt_pwd(pwd)
      pwd_salt = '79d428f0c2eb9c54e7da24ffd9ab87ee2b5b117b53eb755daac31b866a56d667'
      require('digest')
      Digest::SHA256.hexdigest(pwd_salt + pwd)
    end
end
