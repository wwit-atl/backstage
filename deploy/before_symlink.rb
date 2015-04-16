rails_env = new_resource.environment['RAILS_ENV']

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

execute 'rake assets:precompile' do
  user 'deploy'
  cwd release_path
  command 'bundle exec rake assets:precompile'
  environment 'RAILS_ENV' => rails_env
  returns [0, nil]
end

