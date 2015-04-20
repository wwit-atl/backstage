namespace :db do
  local = {
      host: '127.0.0.1',
      port: 5432,
      user: 'dyoung',
      db: 'backstage_development',
      dump: 'localhost.dump',
      limit: 3600
  }
  ninefold = {
      host: '124.47.148.107',
      port: 5432,
      user: 'app',
      db: 'db9968',
      dump: 'ninefold.dump',
      limit: 3600
  }
  heroku = {
      prod: 'wwit-backstage',
      staging: 'wwit-backstage-staging',
      dump: 'heroku.dump',
      limit: 3600
  }
  aws = {
      host: 'aaa0i1u2zjf51q.clc64ittof4h.us-east-1.rds.amazonaws.com',
      port: 5432,
      user: 'wwit',
      db: 'ebdb',
      dump: 'aws.dump',
      limit: 3600,
      bucket: 'wwit-backstage/backups',
      access_key: ENV['AWS_ACCESS_KEY_ID'],
      secret_key: ENV['AWS_SECRET_KEY']
  }

  def abort(message)
    puts message
    exit 1
  end

  def check_file_time(file, limit, abort = true)
    time = Time.now - File.ctime(file) if File.exists?(file)
    if time.nil? or time > limit
      File.unlink(file) if File.exists?(file)
    else
      if abort
        abort "We've pushed a backup in the last #{limit} minutes, aborting (use FORCE=true to override)."
      else
        puts "Using existing #{file} file."
      end
    end
  end

  def check_dump(dumpfile)
    abort "Whoops! #{dumpfile} is empty or does not exist. Cannot continue." unless File.size?(dumpfile)
  end

  # Clone database to Development
  desc 'clone production database to development'
  task :clone do
    check_file_time( ninefold[:dump], local[:limit], false ) unless ENV['FORCE'] == 'true'

    puts 'Cloning production DB to development'

    Bundler.with_clean_env do

      unless File.size?(ninefold[:dump])
        puts 'Retrieving database backup from Ninefold'
        system "pg_dump -w -h '#{ninefold[:host]}' " +
                   "-p #{ninefold[:port]} " +
                   "-U '#{ninefold[:user]}' " +
                   '-a -N postgis -N topology -Fc ' +
                   "-d '#{ninefold[:db]}' -f '#{ninefold[:dump]}'"
      end

      check_dump ninefold[:dump]

      puts "Restoring #{ninefold[:dump]} to #{local[:db]}..."
      system "pg_restore -C -h #{local[:host]} -p #{local[:port]} -U #{local[:user]} -d #{local[:db]} #{ninefold[:dump]}"
    end

  end # :clone

  namespace :push do

    # Push database to Staging
    desc 'Push production database to staging'
    task :staging do
      require 'aws-sdk'

      check_file_time ninefold[:dump], ninefold[:limit] unless ENV['FORCE'] == 'true'

      if aws[:access_key].nil? or aws[:secret_key].nil?
        abort 'No AWS Credentials supplied, please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.'
      end

      puts 'Pushing production DB to staging'

      Bundler.with_clean_env do

        unless File.size?(ninefold[:dump])
          puts 'Retrieving database backup from Ninefold'
          system "pg_dump -c -w -h '#{ninefold[:host]}' " +
                     "-p #{ninefold[:port]} " +
                     "-U '#{ninefold[:user]}' " +
                     '-N postgis -N topology -Fc ' +
                     "-d '#{ninefold[:db]}' -f '#{ninefold[:dump]}'"
        end

        check_dump ninefold[:dump]

        # Need to push to AWS first
        puts "Pushing #{ninefold[:dump]} to AWS..."
        # system "s3cmd put '#{ninefold[:dump]}' 's3://#{aws[:bucket]}'"
        bucket = AWS::S3.new( access_key_id: aws[:access_key], secret_access_key: aws[:secret_key] ).buckets[aws[:bucket]]
        awsobj = bucket.objects[ninefold[:dump]]
        awsobj.write(:file => ninefold[:dump], :acl => :public_read )

        puts "Restoring backup file from #{awsobj.public_url} to Heroku Staging..."
        system "heroku maintenance:on -a #{heroku[:staging]}"
        system "heroku pg:reset DATABASE --confirm wwit-backstage-staging -a #{heroku[:staging]}"
        system "heroku run rake db:migrate -a #{heroku[:staging]}"
        system "heroku pgbackups:restore DATABASE '#{awsobj.public_url}' --confirm wwit-backstage-staging -a #{heroku[:staging]}"
        system "heroku maintenance:off -a #{heroku[:staging]}"

      end

    end # :staging

    # Push database to EBS
    desc 'Push production database to staging'
    task :ebs do
      require 'aws-sdk'

      check_file_time ninefold[:dump], ninefold[:limit] unless ENV['FORCE'] == 'true'

      if aws[:access_key].nil? or aws[:secret_key].nil?
        abort 'No AWS Credentials supplied, please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.'
      end

      puts 'Pushing production DB to EBS'

      Bundler.with_clean_env do

        unless File.size?(ninefold[:dump])
          puts 'Retrieving database backup from Ninefold'
          system 'pg_dump --no-owner --no-acl --no-password --format=custom ' +
                         "-h '#{ninefold[:host]}' " +
                         "-p '#{ninefold[:port]}' " +
                         "-U '#{ninefold[:user]}' " +
                         "-d '#{ninefold[:db]}'   " +
                         "-f '#{ninefold[:dump]}'"
        end

        check_dump ninefold[:dump]

        puts 'Restoring database on EBS'
        system 'pg_restore --clean --no-owner --no-acl --no-password --format=custom ' +
                          "-h '#{aws[:host]}' " +
                          "-p '#{aws[:port]}' " +
                          "-U '#{aws[:user]}' " +
                          "-d '#{aws[:db]}'   " +
                          "#{ninefold[:dump]}"

      end

    end # :ebs

  end # :push
end # :db

