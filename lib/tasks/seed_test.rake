namespace :db do
  namespace :test do
    task :seed do
      Rails.env = 'test'
      Rake::Task['db:seed'].invoke
    end
  end
end