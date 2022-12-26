# frozen_string_literal: true

namespace :db do
  local = {
    host: "127.0.0.1",
    port: 5432,
    user: "postgres",
    db: "backstage_development",
    dump: "tmp/localhost.dump",
    limit: 3600
  }
  aws = {
    staging: {
      host: "wwit-backstage-staging.clc64ittof4h.us-east-1.rds.amazonaws.com",
      port: 5432,
      user: ENV.fetch("RDS_USERNAME", "wwit"),
      pass: ENV.fetch("RDS_PASSWORD", nil),
      db: "backstage-staging",
      bucket: "wwit-backstage-staging/backups",
      dump: "tmp/aws.staging.dump",
      limit: 3600
    },
    prod: {
      host: "wwit.clc64ittof4h.us-east-1.rds.amazonaws.com",
      port: 5432,
      user: ENV.fetch("RDS_USERNAME", "wwit"),
      pass: ENV.fetch("RDS_PASSWORD", nil),
      db: "backstage-prod",
      bucket: "wwit-backstage/backups",
      dump: "tmp/aws.prod.dump",
      limit: 3600
    }
  }

  def abort(message)
    puts message
    exit 1
  end

  def check_file_time(file, limit, abort: true)
    time = Time.now - File.ctime(file) if File.exist?(file)
    if time.nil? || time > limit
      File.unlink(file) if File.exist?(file)
    elsif abort
      abort "We've pushed a backup in the last #{limit} minutes, aborting (use FORCE=true to override)."
    else
      puts "Using existing #{file} file."
    end
  end

  def check_dump(dumpfile)
    abort "Whoops! #{dumpfile} is empty or does not exist. Cannot continue." unless File.size?(dumpfile)
  end

  def db_creds(hash)
    db_auth = hash[:user]
    db_auth += ":#{hash[:pass]}" if hash[:pass].present?

    db_host = "#{hash[:host]}:#{hash[:port]}/#{hash[:db]}"

    [db_auth, db_host]
  end

  def pg_dump(from)
    db_auth, db_host = db_creds(from)

    puts "Retrieving database from #{db_host}"

    system "pg_dump --no-owner --no-acl --no-password --format=custom --dbname='postgresql://#{db_auth}@#{db_host}' -f #{from[:dump]}"
  end

  def pg_restore(to, dumpfile)
    db_auth, db_host = db_creds(to)

    puts "Restoring #{dumpfile} to #{db_host}"

    system "pg_restore --clean --no-owner --no-acl --no-password --format=custom --dbname='postgresql://#{db_auth}@#{db_host}' #{dumpfile}"
  end

  namespace :prod do
    # Clone database to Development
    desc "Create a local production database backup"
    task :backup do
      check_file_time(aws[:prod][:dump], local[:limit], abort: false) unless ENV["FORCE"] == "true"
      pg_dump(aws[:prod]) unless File.size?(aws[:prod][:dump])
    end

    # Clone database to Development
    desc "clone production database to local development"
    task :clone do
      check_file_time(aws[:prod][:dump], local[:limit], abort: false) unless ENV["FORCE"] == "true"

      puts "Cloning production DB to Local Development"

      Bundler.with_clean_env do
        pg_dump(aws[:prod]) unless File.size?(aws[:prod][:dump])
        check_dump(aws[:prod][:dump])
        pg_restore(local, aws[:prod][:dump])
      end
    end
  end

  namespace :push do
    desc "Push production database to staging"
    task :staging do
      check_file_time(aws[:prod][:dump], aws[:prod][:limit]) unless ENV["FORCE"] == "true"

      puts "Cloning production DB to Staging"

      Bundler.with_clean_env do
        pg_dump(aws[:prod]) unless File.size?(aws[:prod][:dump])
        check_dump(aws[:prod][:dump])
        pg_restore(aws[:staging], aws[:prod][:dump])
      end
    end
  end
end
