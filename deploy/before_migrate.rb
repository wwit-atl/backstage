Chef::Log.info("Running deploy/before_migrate.rb...")
Chef::Log.info("Symlinking #{release_path}/public/assets to #{new_resource.deploy_to}/shared/assets")

shared_assets_dir = "#{new_resource.deploy_to}/shared/assets"

directory shared_assets_dir do
  owner 'deploy'
  group 'www-data'
  mode '0770'
  action :create
end

link "#{release_path}/public/assets" do
  to shared_assets_dir
end

rails_env = new_resource.environment["RAILS_ENV"]
Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end
