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
  [ 'MC', 'Master of Ceremonies', '', 'Shift', true  ],
  [ 'HM', 'House Manager',        '', 'Shift', true  ],
  [ 'SM', 'Stage Manager',        '', 'Shift', true  ],
  [ 'LB', 'Lightboard Operator',  '', 'Shift', true  ],
  [ 'SB', 'Soundboard Operator',  '', 'Shift', true  ],
  [ 'CS', 'Camera Operator',      '', 'Shift', true  ],
  [ 'SS', 'Suggestion Taker',     '', 'Shift', false ],
  [ 'BT', 'Bartender',            '', 'Shift', true  ],
  [ 'BO', 'Box Office Attendant', '', 'Shift', true  ],
  [ 'SP', 'Stage Presence', 'How this actor presents themselves on stage', 'Performance', false ],
  [ 'PR', 'Projection', 'How well this actor projects their voice', 'Performance', false ],
].each do |code, name, desc, cat, training|
  unless Skill.where(code: code).exists?
    Skill.create( code: code, name: name, description: desc, category: cat, training?: training )
  end
end
