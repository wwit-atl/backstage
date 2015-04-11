rails_env = new_resource.environment['RAILS_ENV']

Chef::Log.info("Starting worker jobs for RAILS_ENV=#{rails_env}...")

execute 'start delayed_job worker(s)' do
  cwd release_path
  command "RAILS_ENV=#{rails_env} bundle exec bin/delayed_job -n2 start"
  environment 'RAILS_ENV' => rails_env
end

