number_of_workers = new_resource.environment['DJ_WORKERS'] || '2'
rails_env         = new_resource.environment['RAILS_ENV']  || 'production'

if rails_env != 'production'
  Chef::Log.info("Skipping Delayed_Job startup; RAILS_ENV=#{rails_env}")
else
  Chef::Log.info("Starting #{number_of_workers} Delayed_Job worker(s)...")

  execute 'start delayed_job worker(s)' do
    cwd release_path
    command "bin/delayed_job -n#{number_of_workers} start"
    environment new_resource.environment
  end
end

