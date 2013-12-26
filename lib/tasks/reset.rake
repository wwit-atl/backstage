desc 'Reset DB and prepare test database.'
task :reset do
  puts '--> Dropping databases'
  Rake.application.invoke_task('db:drop:all')

  puts '--> Creating databases'
  Rake.application.invoke_task('db:create:all')
  Rake.application.invoke_task('db:migrate')
  Rake.application.invoke_task('db:seed')

  puts '--> Prepping test database'
  Rake.application.invoke_task('db:test:prepare')

  puts '--> Creating development records'
  Rake.application.invoke_task('members:create:all')
  Rake.application.invoke_task('shows:create')
end
