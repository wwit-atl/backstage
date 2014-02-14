require 'yaml'
require 'ostruct'

# Load the YAML file
@db = YAML.load_file('wwit_members.yml')

# Metadata Record Types
@metatypes = [:first_name, :last_name, :phone1, :phone2, :phone3, :address, :city, :state, :zip, :active]

def find_meta(id, type)
  case type
    when :active then key = '_u_active'
    when :address then key = '_u_address'
    when :city   then key = '_u_city'
    when :state  then key = '_u_state'
    when :zip    then key = '_u_zip'
    when :phone1 then key = '_u_home_phone'
    when :phone2 then key = '_u_work_phone'
    when :phone3 then key = '_u_cell_phone'
    else key = type.to_s
  end
  @db.each do |record|
    return record['meta_value'] if record.has_key?('meta_key') and record['meta_key'] == key and record['user_id'] == id
  end
  puts "Could not find #{key} for record-#{id}!"
end

def get_meta(id)
  @metatypes.each { |type| @members[id].merge!( type => find_meta(id, type).to_s.strip ) }
end

# Cleans and removes bad records
def scrub_data(id)
  member = @members[id]

  # Delete records without required fields
  if member[:email].empty? or member[:last_name].empty? or member[:first_name].empty?
    @members.delete(id)
    return true
  end

  # Delete utility accounts
  if %w(Admin Class Business Last).include?(member[:last_name])
    @members.delete(id)
    return true
  end

  # Clean address data
  [:address, :city, :state, :zip].each do |type|
    member[type] = nil if member[type].to_s.downcase == type.to_s
  end

  # Clean phone data
  [:phone1, :phone2, :phone3].each do |phone|
    member[phone] = nil if member[phone].to_s.downcase.gsub(/ /, '') == phone.to_s
  end

  false
end

# Our main container
@members = {}

@db.each do |record|
  next unless record.has_key?('user_email')

  # Grab Member ID and email address
  id = record['ID']
  @members[id] = { :email => record['user_email'] }
end

# We now have all members in the members hash, fill in the metadata and output our file

output = File.new('members.db', 'w')

@members.each_key do |id|
  # populate metadata
  get_meta(id)

  # Clean the data
  next if scrub_data(id)

  # Output the data
  puts ">>> #{@members[id][:first_name]} #{@members[id][:last_name]}"
  output << ([:email] + @metatypes).collect { |type| @members[id][type] }.join(':') + "\n"
end

puts "Wrote #{@members.count} members to #{output.path}"

output.close
