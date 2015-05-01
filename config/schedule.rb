# Use this file to easily define all of your cron jobs.
#
# Learn more: http://github.com/javan/whenever

set :output, './log/whenever.log'

# All times are in UTC

every 1.day, at: '10:00 am' do
  rake 'jobs:schedule:reminders'
end

every :sunday, at: '5:00 am' do
  rake 'jobs:schedule:announcements:archive'
end
