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
    'MemberMaxConflicts' => [ 3, 'The maximum number of conflicts a Member is allowed in a given month.'      ],
    'MemberMinShifts'    => [ 3, 'The minimum number of shifts each Member will be [auto]assigned per month.' ],
    'MemberMaxShifts'    => [ 5, 'The maximum number of shifts each Member will be [auto]assigned per month.' ],
    'CastMinShows'       => [ 5, 'The minimum number of shows a full-cast member is expected to perform in.'  ],
}.each do |key, value|
  Konfig.where(name: key).first_or_create.update_attributes(value: value[0], desc: value[1])
end

#
# Create Roles
#
puts 'Create Roles'
#   Role         Description        Cast?  Crew?
[
  [ :admin,      'Administrator',   false, false ],
  [ :management, 'Management',      false, false ],
  [ :sponsor,    'WWIT Sponsor',    false, false ],
  [ :friend,     'Friend of WWIT',  false, false ],
  [ :alumni,     'WWIT Alumni',     false, false ],
  [ :ms,         'Main Stage Cast', true,  false ],
  [ :apprentice, 'Apprentice Cast', true,  true  ],
  [ :us,         'Unusual Suspects',true,  true  ],
  [ :isp,        'Improv Studies',  true,  true  ],
  [ :volunteer,  'WWIT Volunteer',  false, true  ]
].each do |name, desc, cast, crew|
  #Role.where(name: code).first_or_create.update_attributes( desc: desc, cast: cast, crew: crew )
  Role.create( name: name, desc: desc, cast: cast, crew: crew ) if Role.where('name = ?', name).empty?
end

#
# Create Skills
#
puts 'Create Skills'
#  Pri,  Code,  Name,         Description, train?, autocrew?
[
  [ nil, 'MC', 'Master of Ceremonies', '', true,  false ],
  [ nil, 'MU', 'Musician',             '', true,  false ],
  [ 1,   'HM', 'House Manager',        '', true,  true  ],
  [ 2,   'LS', 'Lightboard Operator',  '', true,  true  ],
  [ 3,   'SS', 'Soundboard Operator',  '', true,  true  ],
  [ 4,   'CS', 'Camera Operator',      '', true,  true  ],
  [ 5,   'SM', 'Stage Manager',        '', true,  true  ],
  [ 6,   'SG', 'Suggestion Taker',     '', false, true  ],
  [ nil, 'BO', 'Box Office Attendant', '', true,  false ],
  [ nil, 'BAR','Bartender',            '', true,  false ],
  [ nil, 'TEACH', 'Improv Teacher',    '', true,  false ]
].each do |priority, code, name, desc, training, autocrew|
  Skill.where(code: code).first_or_create.update_attributes(
    name: name,
    description: desc,
    training: training,
    autocrew: autocrew,
    priority: priority,
  )
end

#
# Create initial Show Templates
#
puts 'Create Show Templates'
#  DoW (Sun = 0), Name,         Call Time,         Show Time,         Associated Skills
[
  [ 2, 'Improv Laboratory',     get_time('18:30'), get_time('20:00'), %w(MC HM LS BO) ],
  [ 4, 'Unusual Suspects',      get_time('18:30'), get_time('20:00'), %w(MC HM LS SS CS BO) ],
  [ 5, 'Friday Night Improv',   get_time('19:30'), get_time('21:00'), %w(MC HM LS SS CS BO MU) ],
  [ 6, 'Saturday Night Improv', get_time('18:30'), get_time('20:00'), %w(MC HM LS SS CS BO) ],
  [ 6, 'Wheel of Improv',       get_time('21:00'), get_time('22:30'), %w(MC) ],
].each do |dow, name, calltime, showtime, skills|
  skill_ids = skills.map{ |code| Skill.where(code: code).first.id }.to_a
  ShowTemplate.where(name: name).first_or_create.update_attributes(
      dow: dow,
      calltime: calltime,
      showtime: showtime,
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
[
    [ 'Chip',        'Powell',       'chip@wholeworldtheatre.com',  [:admin, :management, :ms] ],
    [ 'Emily Reily', 'Russell',      'emily@wholeworldtheatre.com', [:admin, :management, :ms] ],
    [ 'Eric',        'Goins',        'eric@wholeworldtheatre.com',  [:admin, :management, :ms] ],
    [ 'Lauren',      'Revard Goins', 'lauren@wholeworldtheatre.com',[:admin, :management, :ms] ],
    [ 'Donovan C.',  'Young',        'Donovan.C.Young@gmail.com',   [:admin, :us]              ],
    [ 'Matt',        'Griffin',      'Matt.F.Griffin@gmail.com',    [:us]                      ],
].each do |firstname, lastname, email, roles|
  puts "Creating #{firstname} #{lastname}..."
  password = firstname.split.first.downcase + '@wwit'
  if Member.where(email: email).first_or_create.update_attributes(
      firstname: firstname,
      lastname:  lastname,
      email:     email,
      active:    true,
      password:  password,
      password_confirmation: password )

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

