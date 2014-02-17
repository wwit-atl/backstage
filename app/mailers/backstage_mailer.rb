class BackstageMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  before_action :set_headers

  def announcements(message)
    @message = message
    message_id = SecureRandom.uuid

    headers['X-MC-Metadata'] = { message_id: message_id }.to_json

    message.email_message_id = message_id
    message.sent_at = Time.now.utc

    mail ({
           from: message.sender.email_tag,
       reply_to: message.sender.email_tag,
             to: message.sender.email_tag,
            bcc: message.members.email_tags,
        subject: "[WWIT-ANNOUNCEMENT] #{message.subject}",
    })
  end

  def waiting_for_approval(message)
    @message = message
    mail ({
             to: Member.managers.email_tags,
        subject: '[WWIT-ADMIN] New message waiting for approval'
    })
  end

  private

    def set_headers
      headers['X-MC-Autotext'] = 'true'
    end
end
