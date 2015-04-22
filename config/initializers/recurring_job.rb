# RecurringJob should log to rails logger
RecurringJob.logger = Rails.logger

# Require our jobs directory
Dir['lib/jobs/*.rb'].each { |file| require "jobs/#{File.basename(file, '.rb')}" }

# Schedule Jobs
hour = 10 # 6 AM EST, based upon UTC

t = Time.now.utc
t += 1.day if t.hour >= hour
time = Time.utc(t.year, t.month, t.day, hour)
Jobs::EmailCrewReminders.schedule_job(first_start_time: time)

time = Time.now.utc.sunday.midnight + 6.hours
Jobs::PurgeAnnouncements.schedule_job(first_start_time: time)
