desc 'Reset DB and prepare test database.'
task :reset do

  puts '--> Dropping databases'
  Rake::Task['db:drop:all'].invoke

  puts '--> Creating databases'
  Rake::Task['db:create:all'].invoke
  puts '    ... Migrating'
  Rake::Task['db:migrate'].invoke
  puts '    ... Seeding'
  Rake::Task['db:seed'].invoke

  puts '--> Prepping test database'
  Rake::Task['db:test:prepare'].invoke

  puts '--> Creating development records'
  Rake::Task['members:create:all'].invoke
  Rake::Task['shows:create'].invoke

end
