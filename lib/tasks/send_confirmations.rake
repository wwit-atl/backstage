namespace :members do
  namespace :confirmation do

    desc 'Send email confirmation to group members who have not yet received it'
    task :to_group, [ :group ] => :environment do |t, args|
      args.with_defaults(:group => 'ms')

      Member.with_role(args[:group]).readonly(false).each do |member|
        next if member.confirmed?
        puts "Sending confirmation to #{member.email_tag}"
        member.send_confirmation_instructions
      end
    end # task:send

    desc 'Send email confirmation to individual members who have not yet received it'
    task :to_email, [ :email ] => :environment do |t, args|

      if args.empty?
        puts "Please use #{t}['member_email']"
        exit
      end

      email = args[:email]
      member = Member.where(email: email).readonly(false).first

      if member.nil?
        puts "Could not find any members with email #{email}"
        exit
      end

      if member.confirmed?
        puts "#{member.email_tag} was already confirmed.  Nothing to do"
        exit
      end

      puts "Sending confirmation to #{member.email_tag}"
      member.send_confirmation_instructions
    end # task:send_to

  end # namespace:confirmation
end # namespace:members

