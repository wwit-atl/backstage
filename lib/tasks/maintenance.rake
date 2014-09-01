namespace :maintenance do
  namespace :announcements do

    desc 'Remove Announcements older than given days (default = 90)'
    task :archive, [:days] => :environment do |t, args|
      args.with_defaults(:days => 90)

      days = args[:days].to_i
      date = Date.today - days.days

      messages = Message.where('created_at < ?', date).order(:created_at)

      Rails.logger.info "Deleting #{messages.count} Announcements older than #{days} days"
      messages.each(&:destroy)
    end

  end
end
