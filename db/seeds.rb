# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#
# Create an Admin account
#
if Member.joins(:roles).where('roles.name' => 'admin').empty?
  phone = Phone.new(ntype: 'Mobile', number: '4049393709')
  admin = Member.create(
      email:    'admin@example.com',
      password: 'wwit4admin',
      password_confirmation: 'wwit4admin',
      firstname: 'Admin',
      lastname:  'User',
      phones: [phone]
  )
  admin.add_role :admin
  admin.confirm! if admin.respond_to?('confirm!')
end

#
# Create Configs
#
{
    'MemberMaxConflicts' => 3,
    'MemberMinShifts'    => 3,
    'MemberMaxShifts'    => 5,
    'CastMinShows'       => 5,
}.each do |key, value|
  Konfig.where(name: key).first_or_create.update_attributes(value: value)
end

#
# Create Roles
#
%w(
  admin management sponsor friend
  ms apprentice us isp
).each do |role|
  Role.create( name: role ) if Role.where(name: role).empty?
end

#
# Create Skills
#
[
  [ 'MC', 'Master of Ceremonies', '', 'Shift', true, true   ],
  [ 'HM', 'House Manager',        '', 'Shift', true, true   ],
  [ 'SM', 'Stage Manager',        '', 'Shift', true, true   ],
  [ 'LB', 'Lightboard Operator',  '', 'Shift', true, true   ],
  [ 'SB', 'Soundboard Operator',  '', 'Shift', true, true   ],
  [ 'CS', 'Camera Operator',      '', 'Shift', true, true   ],
  [ 'SS', 'Suggestion Taker',     '', 'Shift', false, false ],
  [ 'BT', 'Bartender',            '', 'Shift', true, false  ],
  [ 'BO', 'Box Office Attendant', '', 'Shift', true, false  ],
  [ 'SP', 'Stage Presence', 'How this actor presents themselves on stage', 'Performance', false, true ],
  [ 'PR', 'Projection', 'How well this actor projects their voice', 'Performance', false, true ],
].each do |code, name, desc, cat, training, ranked|
  Skill.where(code: code).first_or_create.update_attributes(
    name: name,
    description: desc,
    category: cat,
    training?: training,
    ranked?: ranked,
  )
end

#
# Create Stages
#
{
  'UR' => 'Up Right',
  'DR' => 'Down Right',
  'SR' => 'Stage Right',
  'UL' => 'Up Left',
  'DL' => 'Down Left',
  'SL' => 'Stage Left',
  'CS' => 'Center Stage',
  'FS' => 'Full Stage',
  'BS' => 'Back Stage',
}.each do |key, value|
  Stage.where(code: key).first_or_create.update_attributes(name: value)
end

