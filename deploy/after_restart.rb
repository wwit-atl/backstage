number_of_workers = new_resource.environment['DJ_WORKERS'] || '2'

Chef::Log.info("Starting #{number_of_workers} Delayed_Job worker(s)...")

execute 'start delayed_job worker(s)' do
  cwd release_path
  command "bin/delayed_job -n#{number_of_workers} start"
  environment new_resource.environment
end

