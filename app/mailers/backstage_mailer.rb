class BackstageMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def announcements(message)
    @message = message
    headers['X-MC-MetaData'] = { id: message.id }
    mail ({
           from: message.sender.email_tag,
             to: message.sender.email_tag,
            bcc: message.members.map{ |m| m.email_tag },
        subject: message.subject,
    })
    message.sent_at = Time.now()
  end
end
