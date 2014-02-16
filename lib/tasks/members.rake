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

  desc 'Extract members from WWIT database to tmp/members.yml'
  task :extract => :environment do
    system "cd #{Rails.root + 'tmp'} && ruby #{Rails.root + 'lib/member_import/extract_members.rb'}"
  end

  desc 'Import Members from tmp/members.yml file'
  task :import => :environment do
    import_file = Rails.root + 'tmp/members.yml'
    puts "Importing members from #{import_file}"
    YAML.load_file(import_file).each do |id, record|
      puts "> Creating #{record['first_name']} #{record['last_name']}..."

      password = record['first_name'].split.first.downcase + '@wwit'
      #password = Devise.friendly_token.first(10)
      member_email = record['email']

      if Member.where(email: member_email).first_or_create.update_attributes(
          firstname: record['first_name'],
          lastname:  record['last_name'],
          email:     member_email,
          active:    ( record['active'].to_i == 1 ),
          password:  password,
          password_confirmation: password,
          slug:      nil # Re-Create the slug for this record (in case the name has changed)
      )

        member = Member.where(email: member_email).first

        # Create Phone Records
        %w(phone1 phone2 phone3).each do |phone|
          types = %w(Home Work Mobile)
          if !record[phone].nil?
            Phone.create(
                member: member,
                ntype:  types[phone.to_i-1],
                number: record[phone],
            )
          end
        end

        # Create Address Record
        if !record['address'].nil?
          Address.create(
              member:  member,
              atype:   'Home',
              street1: record['address'],
              city:    record['city'],
              state:   record['state'],
              zip:     record['zip'],
          )
        end

      end
    end
  end
end
