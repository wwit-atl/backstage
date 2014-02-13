class BackstageMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def announcements(message)
    @message = message

    #headers.message_id = "<#{SecureRandom.uuid}@#{Rails.configuration.action_mailer.smtp_settings[:domain]}>"
    #message.email_message_id = headers.message_id
    message_id = SecureRandom.uuid

    headers['X-MC-Metadata'] = { message_id: message_id }.to_json

    message.email_message_id = message_id
    message.sent_at = Time.now.utc

    mail ({
           from: message.sender.email_tag,
             to: message.sender.email_tag,
            bcc: message.members.map{ |m| m.email_tag },
        subject: message.subject,
    })
  end
end
