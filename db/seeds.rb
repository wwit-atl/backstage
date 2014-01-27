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
puts 'Create Roles'
#   Role         Description        Cast?  Crew?
[
  [ :admin,      'Administrator',   false, false ],
  [ :management, 'Management',      false, false ],
  [ :sponsor,    'WWIT Sponsor',    false, false ],
  [ :friend,     'Friend of WWIT',  false, false ],
  [ :ms,         'Main Stage Cast', false, false ],
  [ :alumni,     'WWIT Alumni',     false, false ],
  [ :apprentice, 'Apprentice Cast', false, false ],
  [ :us,         'Unusual Suspects',false, false ],
  [ :isp,        'Improv Studies',  false, false ],
  [ :volunteer,  'WWIT Volunteer',  false, false ],
  [ :actor,      'Cast Eligible',   true,  false ],
  [ :crew,       'Crew Eligible',   false, true  ]
].each do |code, desc, cast, crew|
  #Role.where(name: code).first_or_create.update_attributes( desc: desc, cast: cast, crew: crew )
  Role.create( name: code, desc: desc, cast: cast, crew: crew )
end

#
# Create Skills
#
puts 'Create Skills'
#  Pri,  Code,  Name,         Description, train?, autocrew?
[
  [ 0,   'MC', 'Master of Ceremonies', '', true,  false ],
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
[
  [ 2, 'Improv Laboratory', get_time('18:30'), get_time('20:00'), %w(MC HM LS BO) ],
  [ 4, 'Unusual Suspects', get_time('18:30'), get_time('20:00'), %w(MC HM LS SS CS BO) ],
  [ 5, 'Friday Night Improv', get_time('19:30'), get_time('21:00'), %w(MC HM LS SS CS BO MU) ],
  [ 6, 'Saturday Night Improv', get_time('18:30'), get_time('20:00'), %w(MC HM LS SS CS BO) ],
  [ 6, 'Wheel of Improv', get_time('21:00'), get_time('22:30'), %w(MC) ],
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
    [ 'Chip',        'Powell',       'chip@wholeworldtheatre.com',  [:admin, :management, :ms, :actor] ],
    [ 'Emily Reily', 'Russell',      'emily@wholeworldtheatre.com', [:admin, :management, :ms, :actor] ],
    [ 'Eric',        'Goins',        'eric@wholeworldtheatre.com',  [:admin, :management, :ms, :actor] ],
    [ 'Lauren',      'Revard Goins', 'lauren@wholeworldtheatre.com',[:admin, :management, :ms, :actor] ],
    [ 'Donovan C.',  'Young',        'dyoung522@gmail.com',         [:admin, :us, :actor, :crew]       ],
].each do |firstname, lastname, email, roles|
  puts "Creating #{firstname} #{lastname}..."
  password = firstname.split.first.downcase + '@wwit'
  if Member.where(email: email).first_or_create.update_attributes(
      firstname: firstname,
      lastname:  lastname,
      email:     email,
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

