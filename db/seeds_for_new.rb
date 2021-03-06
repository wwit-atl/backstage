# This file should contain all the record creation needed to seed the database with base values.

def get_time(time)
  Time.parse('2000-01-01 ' + time.to_s).to_s(:db)
end

#
# Create Skills
#
puts 'Create Skills'
#  Pri,  Code,  Name,         Description, train?, autocrew?, limits?
[
    [ 1,   'HM', 'House Manager',           '', true,  true,  true  ],
    [ 2,   'LS', 'Lightboard Operator',     '', true,  true,  true  ],
    [ 3,   'SS', 'Soundboard Operator',     '', true,  true,  true  ],
    [ 4,   'LSS','Lights & Sound Operator', '', true,  true,  true  ],
    [ 5,   'CS', 'Camera Operator',         '', true,  true,  true  ],
    [ 6,   'SM', 'Stage Manager',           '', true,  true,  true  ],
    [ 7,   'SG', 'Suggestion Taker',        '', false, true,  true  ],
    [ nil, 'MU', 'Musician',                '', true,  false, false ],
    [ nil, 'BO', 'Box Office Attendant',    '', true,  false, false ],
    [ nil, 'BAR','Bartender',               '', true,  false, false ],
    [ nil, 'TEACH', 'Improv Teacher',       '', true,  false, false ]
].each do |priority, code, name, desc, training, autocrew, limits|
  Skill.where(code: code).first_or_create.update_attributes(
      name:        name,
      description: desc,
      training:    training,
      autocrew:    autocrew,
      limits:      limits,
      priority:    priority,
  )
end

#
# Create initial Show Templates
#
puts 'Create Show Templates'
#  DoW (Sun = 0), Name,         Call Time,         Show Time,       Group, Associated Skills
[
    [ 2, 'Improv Laboratory',     get_time('18:30'), get_time('20:00'), :us, %w(HM LSS BO) ],
    [ 4, 'Unusual Suspects',      get_time('18:30'), get_time('20:00'), :us, %w(HM LS SS CS BO) ],
    [ 5, 'Friday Night Improv',   get_time('19:30'), get_time('21:00'), :ms, %w(HM LS SS CS BO MU) ],
    [ 6, 'Saturday Night Improv', get_time('18:30'), get_time('20:00'), :ms, %w(HM LS SS CS BO) ],
    [ 6, 'Wheel of Improv',       get_time('21:00'), get_time('22:30'), :ms, [] ],
].each do |dow, name, calltime, showtime, group, skills|
  skill_ids = skills.map{ |code| Skill.where(code: code).first.id }.to_a
  ShowTemplate.where(name: name).first_or_create.update_attributes(
      dow: dow,
      calltime: calltime,
      showtime: showtime,
      group_id: Role.where(name: group.to_s).first.try(:id),
      skill_ids: skill_ids
  )
end

#
# Create Stages
#
#puts 'Create Stages'
#{
#    'UR' => 'Up Right',
#    'DR' => 'Down Right',
#    'SR' => 'Stage Right',
#    'UL' => 'Up Left',
#    'DL' => 'Down Left',
#    'SL' => 'Stage Left',
#    'CS' => 'Center Stage',
#    'FS' => 'Full Stage',
#    'BS' => 'Back Stage',
#}.each do |code, name|
#  Stage.where(code: code).first_or_create.update_attributes(name: name)
#end

#
# Create Members
#
ENV['NO_EMAIL'] = 'true'
[
    [ 'Guest',       'Volunteer',    'volunteer@wholeworldtheatre.com', [:volunteer                   ] ],
    [ 'Eric',        'Goins',        'eric@wholeworldtheatre.com',      [:admin, :management, :ms, :mc] ],
    [ 'Chip',        'Powell',       'chip@wholeworldtheatre.com',      [:management, :ms, :mc        ] ],
    [ 'Emily Reily', 'Russell',      'emily@wholeworldtheatre.com',     [:management, :ms, :mc        ] ],
    [ 'Lauren',      'Revard Goins', 'lauren@wholeworldtheatre.com',    [:management, :ms, :mc        ] ],
    [ 'Elizabeth',   'King',         'elizabeth.mccown.king@gmail.com', [:management, :us             ] ],
    [ 'Donovan C.',  'Young',        'Donovan.C.Young@gmail.com',       [:admin, :us                  ] ],
].each do |firstname, lastname, email, roles|
  puts "Creating #{firstname} #{lastname}..."
  password = firstname.split.first.downcase + '@wwit'
  if Member.where(email: email).first_or_create.update_attributes(
      firstname: firstname,
      lastname:  lastname,
      email:     email,
      active:    true,
      password:  password,
      password_confirmation: password,
      slug:      nil # Re-Create the slug for this record (in case the name has changed)
  )

    member = Member.where(email: email).first
    roles.each { |role| member.add_role role.to_sym }
    member.confirm! if member.respond_to?('confirm!')

  end
end
