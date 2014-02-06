class ApplicationController < ActionController::Base
  check_authorization :unless => :devise_controller?
  #check_authorization
  #skip_authorization_check :devise_controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_member!
  before_action :configure_permitted_parameters, :if => :devise_controller?

  alias_method :current_user, :current_member

  def admin_only!
    unauthorized unless ( current_member and current_member.is_admin? )
  end
  helper_method :admin_only!

  def authorized?(member = Member.none)
    unauthorized unless ( current_member and ( current_member.is_admin? or current_member.id == member.id ) )
  end

  def unauthorized(alert = nil)
    render 'public/403', :status => :unauthorized, :alert => alert
  end

  def new_messages
    # This should return the number of new messages based upon:
    # current_member.last_message_id
    # messages.maximum(:id)
  end
  protected

    rescue_from CanCan::AccessDenied do |exception|
      if current_user.nil?
        session[:next] = request.fullpath
        redirect_to new_member_sessions_path, :alert => 'You must log in to continue.'
      else
        if request.env["HTTP_REFERER"].present?
          redirect_to :back, :alert => exception.message
        else
          redirect_to back_to_path, :alert => exception.message
        end
      end
    end


  private

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.for(:account_update) { |u|
        u.permit(:password, :password_confirmation, :current_password)
      }
    end

end
