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
end
