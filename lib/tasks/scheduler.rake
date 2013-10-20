namespace :shows do
  desc 'Create Shows for given Month, Year'
  task :create, [ :month, :year ] => :environment do |t, args|
    args.with_defaults(:month => Time.now.month, :year => Time.now.year)
    puts "Creating shows for #{args[:year]}/#{args[:month]}"
    ShowTemplate.create_shows_for(args[:month], args[:year])
  end

  desc 'Automatically crew all available shifts'
  task :schedule => :environment do
    puts 'Scheduling all shows'
    Show.schedule
  end
end
