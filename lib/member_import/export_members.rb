require 'yaml'
require 'ostruct'

OUTPUT = 'members.yml'

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
  puts ">> Could not find #{key} for record-#{id}!"
end

def get_meta(id)
  @metatypes.each { |type| @members[id].merge!( type => find_meta(id, type.to_sym).to_s.strip ) }
end

# Cleans and removes bad records
def scrub_data(id)
  member = @members[id]

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

  true
end

# Load the YAML file
@db = YAML.load_file('wwit_members.yml')

# Metadata Record Types
#@metatypes = [:first_name, :last_name, :phone1, :phone2, :phone3, :address, :city, :state, :zip, :active]
@metatypes = %w(first_name last_name phone1 phone2 phone3 address city state zip active)

# Our main container
@members = {}

@db.each do |record|
  next unless record.has_key?('user_email')

  # Grab Member ID and email address
  id = record['ID']
  @members[id] = { 'email' => record['user_email'] }
end

# We now have all members in the members hash, fill in the metadata and output our file

@members.each_key do |id|
  email = @members[id]['email']

  print ">> #{email} #{'.' * (40 - email.length)} "

  # populate metadata
  get_meta(id)

  # Clean the data
  unless scrub_data(id)
    puts 'UNCLEAN - REMOVED'
    @members.delete(id)
    next
  end

  puts 'OKAY'
end

# Output the data
File.open(OUTPUT, 'w') { |f| f.write @members.sort_by{ |id| id }.to_yaml }

puts "Wrote #{@members.count} members to #{OUTPUT}"

