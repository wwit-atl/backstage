class BackstageMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  before_action :set_headers

  def announcements(message)
    @message = message

    message.email_message_id = set_message_id
    message.sent_at = Time.now.utc

    add_tag(:announcement)

    mail ({
           from: message.sender.email_tag,
             to: message.sender.email_tag,
       reply_to: message.sender.email_tag,
            bcc: message.members.email_tags - message.sender.email_tag,
        subject: "[WWIT-ANNOUNCEMENT] #{message.subject}",
    })
  end

  def waiting_for_approval(message)
    @message = message

    add_tag(:admin)

    mail ({
             to: Member.managers.email_tags,
        subject: '[WWIT-ADMIN] New message waiting for approval'
    })
  end

  def casting_announcement(show)
    @show = show

    add_tag(:casting)

    mail_opts = {
            bcc: Member.company_members.email_tags,
        subject: "[WWIT-CASTING] Cast List for #{@show.human_date} @#{@show.show_time}"
    }
    mail_opts.merge!( reply_to: @show.mc.email_tag ) if @show.mc

    mail mail_opts
  end

  private
    def add_tag(tag)
      return # fix bug!
      return unless tag
      headers['X-MC-Tags'] = ( headers['X-MC-Tags'].split(',').map(&:strip) << tag ).join(', ')
    end

    def set_message_id
      message_id = SecureRandom.uuid
      headers['X-MC-Metadata'] = { message_id: message_id }.to_json
      message_id
    end

    def set_headers
      headers['X-MC-Tags']  = '' if headers['X-MC-Tags'].nil?
      headers['X-MC-Track'] = 'opens, clicks'
    end
end
