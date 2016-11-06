class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if session[:current_user_id] == nil
      redirect_to login_url, :flash => { error: "请先登录" }
    else
      redirect_to profile_url, :flash => { error: "权限不够" }
    end
  end

  def authenticate_admin_user!
    redirect_to root_url unless current_user and current_user.has_role? :admin
  end

  def current_user
    user ||= User.find_by school_id: session[:current_user_id]
    user
  end
end
