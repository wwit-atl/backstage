namespace :jobs do
  namespace :run do
    namespace :announcements do

      desc 'Remove Announcements older than given days (default = 90)'
      task :archive, [:days] => :environment do |t, args|
        args.with_defaults(:days => 90)
        Jobs::PurgeAnnouncements.new.perform( days: args[:days].to_i )
      end

    end

    desc 'Send reminder email to shift members'
    task :reminders => :environment do
      Jobs::EmailCrewReminders.new.perform
    end
  end
end
