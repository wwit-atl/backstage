namespace :members do
  namespace :confirmation do

    desc 'Send email confirmation to members that have not yet received it'
    task :send, [ :group ] => :environment do |t, args|
      args.with_defaults(:group => 'ms')

      Member.with_role(args[:group]).readonly(false).each do |member|
        next if member.confirmed?
        puts "Sending confirmation to #{member.email_tag}"
        member.send_confirmation_instructions
      end
    end # task:send

  end # namespace:confirmation
end # namespace:members

