# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#
# Create Roles
#

%w(
  admin
  management
  main_stage
  apprentice
  unusual_suspect
  isp
  sponsor
  friend
).each do |role|
  Role.create( name: role ) unless Role.where(name: role).exists?
end

#
# Create an Admin account
#
unless Member.joins(:roles).where('roles.name' => 'admin').exists?
  phone = Phone.new(ntype: 'Mobile', number: '4049393709')
  admin = Member.create(
      username: 'admin',
      password: 'wwit4admin',
      password_confirmation: 'wwit4admin',
      email:    'admin@example.com',
      firstname: 'Admin',
      lastname:  'User',
      phones: [phone]
  )
  admin.add_role :admin
  admin.confirm!
end

#
# Create Skills
#
[
  [ 'MC', 'Master of Ceremonies', true  ],
  [ 'HM', 'House Manager',        true  ],
  [ 'SM', 'Stage Manager',        true  ],
  [ 'LB', 'Lightboard Operator',  true  ],
  [ 'SB', 'Soundboard Operator',  true  ],
  [ 'CS', 'Camera Operator',      true  ],
  [ 'SS', 'Suggestion Taker',     false ],
  [ 'BT', 'Bartender',            true  ],
  [ 'BO', 'Box Office Attendant', true  ],
].each do |name, desc, training|
  unless Skill.where(name: name).exists?
    Skill.create( name: name, description: desc, training?: training )
  end
end
