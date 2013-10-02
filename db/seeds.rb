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
  unless Skill.where(code: code).exists?
    Skill.create(
        code: code,
        name: name,
        description: desc,
        category: cat,
        training?: training,
        ranked?: ranked,
    )
  end
end

#
# Create Stages
#
[
    [ 'UR', 'Up Right'     ],
    [ 'DR', 'Down Right'   ],
    [ 'SR', 'Stage Right'  ],
    [ 'UL', 'Up Left'      ],
    [ 'DL', 'Down Left'    ],
    [ 'SL', 'Stage Left'   ],
    [ 'CS', 'Center Stage' ],
    [ 'FS', 'Full Stage'   ],
    [ 'BS', 'Back Stage'   ],
].each do |code, name|
  unless Stage.where(code: code).exists?
    Stage.create(
      code: code,
      name: name,
    )
  end
end
