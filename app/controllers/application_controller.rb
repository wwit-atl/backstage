class ApplicationController < ActionController::Base
  check_authorization :unless => :devise_controller?
  #check_authorization
  #skip_authorization_check :devise_controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_member!
  before_action :configure_permitted_parameters, :if => :devise_controller?
  before_action :set_host
  before_action :set_referrer, except: [:create, :update, :destroy]

  alias_method :current_user, :current_member

  def default_url_options
    {
        host:   ENV['RAILS_HOST'] || 'backstage.wholeworldtheatre.com',
        locale: I18n.locale
    }
  end

  def unauthorized(alert = nil)
    render 'public/403', :status => :unauthorized, :alert => alert
  end

  def new_messages
    # This should return the number of new messages based upon:
    # current_member.last_message_id
    # messages.maximum(:id)
  end

  def set_referrer
    # Do nothing if it's a refresh
    return if request.url == request.referrer

    # Create the array if it doesn't exist
    session[:redirect_to] = [] unless session[:redirect_to].kind_of?(Array)

    if request.url == session_referrer
      # If we've gone back, pop it off the stack
      session[:redirect_to].pop
    else
      # Push our referrer onto the array unless we came from an edit page or it's already on the stack
      session[:redirect_to].push request.referrer unless request.referrer =~ /(edit|sign_in)/ or
                                                         request.referrer == session_referrer
    end

    # Clean up the session array so it doesn't grow too large
    session[:redirect_to].shift(session[:redirect_to].count - 10) if session[:redirect_to].count > 10

    # Don't return anything
    nil
  end

  def session_referrer
    session[:redirect_to][-1]
  end
  helper_method :session_referrer

  def redirect_back_to(url = root_path, opts = {})
    redirect_to session_referrer || url, opts
  end

  def test_mode
    Rails.env != 'production'
  end
  helper_method :test_mode

  protected

    rescue_from CanCan::AccessDenied do |exception|
      if current_user.nil?
        session[:next] = request.fullpath
        redirect_to new_member_sessions_path, :alert => 'You must log in to continue.'
      else
        if request.env['HTTP_REFERER'].present? and ( request.env['HTTP_REFERER'] != request.original_url )
          redirect_to :back, :alert => exception.message
        else
          redirect_to root_path, :alert => exception.message
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

    def set_host
      @hostname = request.host || 'backstage.wholeworldtheatre.com'
      @hosturl  = request.url  || "http://#{@hostname}"
    end
end
