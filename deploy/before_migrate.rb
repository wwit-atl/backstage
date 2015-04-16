rails_env = new_resource.environment['RAILS_ENV']

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

execute 'rake assets:precompile' do
  command 'bundle exec rake assets:precompile'
  user 'deploy'
  cwd release_path
  environment 'RAILS_ENV' => rails_env
  returns [0, :nothing]
end

