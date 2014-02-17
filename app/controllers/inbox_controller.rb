class InboxController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_member!

  include Mandrill::Rails::WebHookProcessor
  authenticate_with_mandrill_keys! ENV['MANDRILL_WEBHOOK_KEY']

  def handle_send(event_payload)
    puts '>>> Send Event Received'

    return if event_payload.nil?
    return unless event_payload['msg'].has_key?('metadata')

    message_id = event_payload['msg']['metadata']['message_id']
    return if message_id.nil?

    puts ">>> Received WebHook for message_id: #{message_id}"

    message = Message.where(email_message_id: message_id).first
    if message.nil?
      puts '>>> No message matches'
    else
      puts ">>> Applying to message #{message.id}"

      message.delivered_at = Time.at(event_payload['ts']).to_datetime.utc
      message.save
    end
  end

end