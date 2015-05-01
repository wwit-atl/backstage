module Jobs
  class PurgeAnnouncements < RecurringJob

    def perform(opts = {})
      purge_after = opts[:days] || 90
      purge_date = Date.today - purge_after.days

      messages = Message.where('created_at < ?', purge_date).order(:created_at)

      Audit.logger :system, "Deleting #{messages.count} Announcements older than #{purge_after} days"
      messages.each(&:destroy)
    end

    def self.default_interval
      1.week
    end

  end
end
