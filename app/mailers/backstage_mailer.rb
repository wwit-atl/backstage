class BackstageMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def announcements(message)
    @message = message
    members = message.members || Member.company_members
    mail_hash = {
           from: message.sender.email_tag,
             to: message.sender.email_tag,
            bcc: members.map{ |m| m.email_tag },
        subject: message.subject
    }
    mail mail_hash
    message.sent_at = Time.now()
  end
end
