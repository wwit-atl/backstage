namespace :jobs do
  namespace :schedule do
    namespace :announcements do

      desc 'Remove Announcements older than given days (default = 90)'
      task :archive, [:days] => :environment do |t, args|
        args.with_defaults(:days => 90)

        days = args[:days].to_i
        date = Date.today - days.days

        messages = Message.where('created_at < ?', date).order(:created_at)

        Audit.logger :system, "Deleting #{messages.count} Announcements older than #{days} days"
        messages.each(&:destroy)
      end

    end

    desc 'Send reminder email to shift members'
    task :reminders => :environment do
      Shift.for_date(Date.today).each do |shift|
        Audit.logger :mail, "Sending reminder to #{shift.member.fullname.strip} for #{shift.skill.name.strip} on #{shift.show.gregorian_date}"
        BackstageMailer.schedule_reminder(shift).deliver_now
      end
    end
  end
end
