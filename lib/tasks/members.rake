# Create Fake Members for development
namespace :members do
  namespace :create do

    desc 'Create sample Main Stage Members'
    task :ms => :environment do
      puts 'Create Main Stage Members'
      15.times { FactoryGirl.create(:member, :with_phones, :ms) }
    end

    desc 'Create sample Unusual Suspect Members'
    task :us => :environment do
      puts 'Create Unusual Suspects'
      20.times { FactoryGirl.create(:member, :with_phones, :with_conflicts, :us) }
    end

    desc 'Create sample Improv Studies Members'
    task :isp => :environment do
      puts 'Create ISP Members'
      10.times { FactoryGirl.create(:member, :with_phones, :isp) }
    end

    desc 'Give random members training in skills'
    task :train => :environment do
      puts 'Training Crew'
      Member.crewable.order('RANDOM()').limit(20).each do |m|
        m.skills << Skill.with_code(:hm)
        m.skills << Skill.with_code(:ls)
        m.skills << Skill.with_code(:cs)
      end
    end

    desc 'Create all sample Members'
    task :all => [:ms, :us, :isp, :train]
  end

  desc 'Import Members from wwit_members.yml file on S3'
  task :import => :environment do
    require Rails.root + 'lib/member_import/extract_members'

    # We don't want to send out mass-emails during import
    ENV['NO_EMAIL'] = 'true'

    puts 'Importing members'

    YAML.load(WWIT::Import.to_yaml).each do |id, record|

      member_email = record['email'].strip.downcase
      member = Member.where(email: member_email).first_or_create

      puts "> #{member.new_record? ? 'Creating' : 'Updating'} #{record['first_name']} #{record['last_name']} (#{member_email})"

      member.firstname = record['first_name']
      member.lastname  = record['last_name']
      member.email     = member_email
      member.active    = ( record['active'].to_i == 1 )
      member.slug      = nil # Re-Create the slug for this record (in case the name has changed)

      if member.new_record?
        password = Devise.friendly_token.first(10)
        member.password = password
        member.password_confirmation = password
      end

      # Create Phone Records
      %w(phone1 phone2 phone3).each do |phone|
        types = %w(Home Work Mobile)
        if !record[phone].nil?
          number = record[phone].gsub!(/\D/, '')
          member.phones.where(number: number).first_or_create.update_attributes(
              member: member,
              ntype:  types[phone[/\d/].to_i - 1],
              number: number,
          )
        end
      end

      # Create Address Record
      if !record['address'].nil?
        member.addresses.where(street1: record['address']).first_or_create.update_attributes(
            member:  member,
            atype:   'Home',
            street1: record['address'],
            city:    record['city'],
            state:   record['state'],
            zip:     record['zip'],
        )
      end

      unless member.save
        puts "Whoops -- could not save #{member.name}:"
        member.errors.full_messages.each do |msg|
          puts msg
        end
      end
    end
  end
end
