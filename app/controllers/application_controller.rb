class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_member!
  #before_filter :configure_permitted_parameters, if: :devise_controller?

  def admin_only!
    if current_member and ! current_member.is_admin?
      render 'public/403', :status => :unauthorized
    end
  end
  helper_method :admin_only!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end
end
