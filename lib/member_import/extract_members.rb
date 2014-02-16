module WWIT
  module Import
    require 'yaml'
    require 'ostruct'
    require 'open-uri'

    @verbose = false
    @db = []

    def self.to_yaml(verbose = false)
      @verbose = verbose

      # Output the data
      load_members.sort_by{ |id| id }.to_yaml
    end

    def self.load_members
      members = {}

      # Load the YAML file
      @db = YAML.load open('https://s3.amazonaws.com/wwit_backstage/wwit_members.yml')

      # Metadata Record Types
      @metatypes = %w(first_name last_name phone1 phone2 phone3 address city state zip active)

      @db.each do |record|
        next unless record.has_key?('user_email')

        # Grab Member ID and email address
        members[record['ID']] = { 'email' => record['user_email'] }
      end

      # We now have all members in the members hash, fill in the metadata

      members.each_key do |id|
        email = members[id]['email']

        print ">> #{email} #{'.' * (40 - email.length)} " if @verbose

        # populate metadata
        get_meta(members[id], id)

        # Clean the data
        unless scrub_data(members[id])
          puts 'UNCLEAN - REMOVED' if @verbose
          members.delete(id)
          next
        end

        puts 'OKAY' if @verbose
      end

      puts "Loaded #{members.count} members" if @verbose

      members
    end

    private

      class << self
        def find_meta(id, type)
          case type
            when :active  then key = '_u_active'
            when :address then key = '_u_address'
            when :city    then key = '_u_city'
            when :state   then key = '_u_state'
            when :zip     then key = '_u_zip'
            when :phone1  then key = '_u_home_phone'
            when :phone2  then key = '_u_work_phone'
            when :phone3  then key = '_u_cell_phone'
            else key = type.to_s
          end
          @db.each do |record|
            return record['meta_value'] if record.has_key?('meta_key') and record['meta_key'] == key and record['user_id'] == id
          end
          puts ">> Could not find #{key} for record-#{id}!" if @verbose
        end

        def get_meta(member, id)
          @metatypes.each { |type| member.merge!( type => find_meta(id, type.to_sym).to_s.strip ) }
        end

        # Cleans and removes bad records
        def scrub_data(member)

          # Delete records without required fields
          return false if member['email'].empty? or member['last_name'].empty? or member['first_name'].empty?

          # Delete utility accounts
          return false if %w(Admin Class Business Last).include?(member['last_name'])

          # Clean address data
          %w(address city state zip).each { |type| member[type] = nil if member[type].to_s.downcase == type }

          # Clean phone data
          %w(phone1 phone2 phone3).each do |phone|
            member[phone] = nil if member[phone].to_s.downcase.gsub(/ /, '') == phone or
                                   member[phone].to_i == 0
          end
          member['phone2'] = nil if member['phone2'] == member['phone1']
          member['phone3'] = nil if member['phone3'] == member['phone1']

          true
        end
      end
    # End Private
  end
end

if __FILE__ == $0
  puts 'Writing members to members.yml'
  File.open('members.yml', 'w') { |f| f.write WWIT::Import.to_yaml(true) }
end
