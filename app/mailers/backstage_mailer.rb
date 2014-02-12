class BackstageMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def announcements(message)
    @message = message

    headers.message_id = "<#{SecureRandom.uuid}@wwit-backstage>"
    message.email_message_id = headers.message_id
    message.sent_at = Time.now()

    mail ({
           from: message.sender.email_tag,
             to: message.sender.email_tag,
            bcc: message.members.map{ |m| m.email_tag },
        subject: message.subject,
    })
  end
end
