namespace :db do
  namespace :push do
    ninefold = {
        ip: '124.47.148.107',
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
        bucket: 'wwit-backstage/backups',
        access_key: ENV['AWS_ACCESS_KEY_ID'],
        secret_key: ENV['AWS_SECRET_ACCESS_KEY']
    }

    def abort(message)
      puts message
      exit 1
    end

    def check_file_time(file, limit)
      time = Time.now - File.ctime(file) if File.exists?(file)
      if time.nil? or time > limit
        File.unlink(file) if File.exists?(file)
      else
        abort "We've pushed a backup in the last #{limit} minutes, aborting (use FORCE=true to override)."
      end
    end

    def check_dump(dumpfile)
      abort "Whoops! #{dumpfile} does not exist. Cannot continue." unless File.exists?(dumpfile)
    end

    # Push database to Staging
    desc 'Push production database to staging'
    task :to_staging do
      require 'aws-sdk'

      check_file_time ninefold[:dump], ninefold[:limit] unless ENV['FORCE'] == 'true'

      if aws[:access_key].nil? or aws[:secret_key].nil?
        abort 'No AWS Credentials supplied, please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.'
      end

      puts 'Pushing production DB to staging'

      Bundler.with_clean_env do

        unless File.exists?(ninefold[:dump])
          puts 'Retrieving database backup from Ninefold'
          system "pg_dump -w -h '#{ninefold[:ip]}' " +
                   "-p #{ninefold[:port]} " +
                   "-U '#{ninefold[:user]}' " +
                   '-a -N postgis -N topology -Fc ' +
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
        system "heroku pgbackups:restore DATABASE '#{awsobj.public_url}' --confirm wwit-backstage-staging -a #{heroku[:staging]}"
        system "heroku run rake db:migrate -a #{heroku[:staging]}"
        system "heroku maintenance:off -a #{heroku[:staging]}"

      end

    end # :to_staging

  end # :push
end # :db

