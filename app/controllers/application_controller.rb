class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :admin?

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def only_admins
    redirect_to root_path unless admin?
  end

  def admin?
    current_user.try(:admin?)
  end

  protected

  def configure_permitted_parameters
    sanitize_sign_up
    sanitize_sign_in
    sanitize_account_update
  end

  def sanitize_sign_up
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username,
               :email,
               :password,
               :password_confirmation,
               :remember_me)
    end
  end

  def sanitize_sign_in
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login, :username, :email, :password, :remember_me)
    end
  end

  def sanitize_account_update
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username,
               :email,
               :password,
               :password_confirmation,
               :current_password)
    end
  end
end
