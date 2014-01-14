class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_member!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  alias_method :current_user, :current_member

  def admin_only!
    unauthorized unless ( current_member and current_member.is_admin? )
  end
  helper_method :admin_only!

  def authorized?(member = Member.none)
    unauthorized unless ( current_member and ( current_member.is_admin? or current_member.id == member.id ) )
  end

  def unauthorized
    render 'public/403', :status => :unauthorized
  end

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
