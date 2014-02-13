class InboxController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_member!

  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV['MANDRILL_WEBHOOK_KEY']

  def handle_send(event_payload)
    # ToDo: Add delivered_at date to messages in event_payload
    message_id = event_payload['medadata']
    message = Message.where(email_message_id: message_id).first
    if !message.nil?
      message.delivered_at = Time.at(event_payload['ts']).to_datetime
      message.save
    else
      puts "Could not find message for #{message_id}"
      puts event_payload.inspect
    end
  end

end