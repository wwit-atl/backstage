Chef::Log.info("Starting worker jobs...")

execute 'start delayed_job worker(s)' do
  cwd release_path
  command 'bin/delayed_job -n2 start'
  environment new_resource.environment
end

