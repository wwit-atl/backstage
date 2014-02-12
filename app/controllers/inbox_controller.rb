class InboxController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_member!

  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV['MANDRILL_WEBHOOK_KEY']

  def handle_send(event_payload)
    # ToDo: Add delivered_at date to messages in event_payload
    message = Message.where(email_message_id: event_payload.message_id).first
    if !message.nil?
      message.delivered_at = Time.at(event_payload['ts']).to_datetime
      message.save
    else
      logger.info "Could not find message for #{event_payload.message_id}"
    end
  end

end