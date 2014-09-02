# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

def get_time(time)
  Time.parse('2000-01-01 ' + time.to_s).to_s(:db)
end

#
# Create Configs
#
puts 'Create Configuration'
{
    'MemberMaxConflicts' => [ 4, 'The maximum number of conflicts a Member is allowed in a given month.'      ],
    'MemberMinShifts'    => [ 3, 'The minimum number of shifts each Member will be [auto]assigned per month.' ],
    'MemberMaxShifts'    => [ 4, 'The maximum number of shifts each Member will be [auto]assigned per month.' ],
    'CastMinShows'       => [ 5, 'The minimum number of shows a full-cast member is expected to perform in.'  ],
}.each do |key, value|
  Konfig.where(name: key).first_or_create.update_attributes(value: value[0], desc: value[1])
end

#
# Create Roles
#
puts 'Create Roles'
#   Role         Cast?  Crew?  cm?    Sched? Title                  Description
[
  [ :admin,      false, false, false, false, 'Administrator',       'Full Access to all Site Feature'                    ],
  [ :management, false, false, true,  false, 'Management Team',     'Part of the WWIT Management Team, heightened access'],
  [ :sponsor,    false, false, false, false, 'WWIT Sponsor',        'Sponsor, limited access to site functionality'      ],
  [ :friend,     false, false, false, false, 'Friend of WWIT',      'Friend, limited access to site functionality'       ],
  [ :alumni,     false, false, false, false, 'WWIT Alumni',         'Former Company Member, limited access'              ],
  [ :mc,         false, false, false, false, 'Master of Ceremonies','MC, able to cast shows'                             ],
  [ :ms,         true,  true,  true,  false, 'Main Stage Cast',     'Main Stage Performer, normal access'                ],
  [ :apprentice, true,  true,  true,  true,  'Apprentice Cast',     'Apprentice Performer, normal access'                ],
  [ :us,         true,  true,  true,  true,  'Unusual Suspects',    'Unusual Suspects Performer, normal access'          ],
  [ :isp,        true,  true,  true,  true,  'Improv Studies',      'ISP Performer, normal access'                       ],
  [ :student,    false, true,  false, false, 'WWIT Student',        'Improv Student, limited access'                     ],
  [ :staff,      false, true,  true,  true,  'Staff Member',        'Official Company Staff, normal access'              ],
  [ :volunteer,  false, true,  false, false, 'WWIT Volunteer',      'Volunteer, limited access'                          ],
].each do |code, cast, crew, cm, sched, title, desc|
  Role.where(name: code.to_s).first_or_create.update_attributes(
      title:    title,
      desc:     desc,
      cast:     cast,
      crew:     crew,
      cm:       cm,
      schedule: sched
  )
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

#
# FailSafe: Create an Admin account ONLY when necessary
#
if Member.joins(:roles).where('roles.name' => 'admin').empty?
  puts 'Create Admin account'
  note  = Note.new(content: 'This is a temporary Administrative account, used to set up additional admins.  Please remove when possible.')
  admin = Member.create(
      firstname: 'Admin',
      lastname:  'Admin',
      email:    'admin@example.com',
      password: 'admin4wwit',
      password_confirmation: 'admin4wwit',
      notes: [note]
  )
  unless admin.valid?
    puts 'Could not create Admin Account!'
    puts admin.errors.messages.to_s
    exit
  end

  admin.add_role :admin
  admin.confirm! if admin.respond_to?('confirm!')
end

