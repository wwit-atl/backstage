desc 'Reset DB and prepare test database.'
task :reset => [ 'db:reset', 'db:test:prepare', 'members:create:all' ]