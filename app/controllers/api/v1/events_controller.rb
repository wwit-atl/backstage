class Api::V1::EventsController < ActionController::Base
  skip_authorization_check

  before_filter :check_auth
  respond_to :json

  def events
    begin
      date = Date.parse(params[:date])
    rescue
      respond_with( { :status => :unprocessable_entity }, status: 400 )
      return
    end

    @events = Show.for_month(date)

    if @events.empty?
      respond_with( { :status => :not_found }, status: 404 )
    end
  end

  def event
    @event = Show.find(params[:id])
  end

  private

  def check_auth
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end
end
