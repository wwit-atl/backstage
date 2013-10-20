desc 'Reset DB and prepare test database.'
task :reset do
  Rake.application.invoke_task('db:reset')
  Rake.application.invoke_task('db:test:prepare')
  Rake.application.invoke_task('members:create:all')
  Rake.application.invoke_task('shows:create')
  Rake.application.invoke_task('shows:create[09]')
  Rake.application.invoke_task('shows:create[11]')
end
