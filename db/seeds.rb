# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

def get_time(time)
  Time.parse('2000-01-01 ' + time.to_s).to_s(:db)
end

#
# Create an Admin account
#
puts 'Create Admin account'
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
#   Role         Cast?  Crew?
[
  [ :admin,      false, false ],
  [ :management, false, false ],
  [ :sponsor,    false, false ],
  [ :friend,     false, false ],
  [ :ms,         true,  false ],
  [ :apprentice, true,  true  ],
  [ :us,         true,  true  ],
  [ :isp,        true,  true  ],
  [ :volunteer,  false, true  ],
].each do |role, cast, crew|
  if Role.where(name: role).first_or_create.update_attributes(
    name: role, cast: cast, crew: crew
  )
  end
end

#
# Create Skills
#
puts 'Create Skills'
#  Pri,  Code,  Name,         Description, cat,   train?, rank?, autocrew?
[
  [ 0,   'MC', 'Master of Ceremonies', '', 'crew', true,  true,  false ],
  [ 1,   'HM', 'House Manager',        '', 'crew', true,  true,  true  ],
  [ 2,   'LS', 'Lightboard Operator',  '', 'crew', true,  true,  true  ],
  [ 3,   'SS', 'Soundboard Operator',  '', 'crew', true,  true,  false ],
  [ 4,   'CS', 'Camera Operator',      '', 'crew', true,  true,  true  ],
  [ 5,   'BO', 'Box Office Attendant', '', 'crew', true,  false, true  ],
  [ 6,   'SM', 'Stage Manager',        '', 'crew', false, true,  true  ],
  [ 9,   'SG', 'Suggestion Taker',     '', 'crew', false, false, true  ],
  [ nil, 'BAR','Bartender',            '', 'crew', true,  false, false ],
  [ nil, 'ACTOR','Actor',              '', 'cast', true,  true,  false ],
  [ nil, 'SP', 'Stage Presence', 'How this actor presents themselves on stage', 'performance', false, true, false ],
  [ nil, 'PR', 'Projection',     'How well this actor projects their voice',    'performance', false, true, false ],
].each do |priority, code, name, desc, cat, training, ranked, autocrew|
  Skill.where(code: code).first_or_create.update_attributes(
    name: name,
    description: desc,
    category: cat,
    training?: training,
    ranked?: ranked,
    autocrew?: autocrew,
    priority: priority,
  )
end

#
# Create Stages
#
puts 'Create Stages'
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
}.each do |code, name|
  Stage.where(code: code).first_or_create.update_attributes(name: name)
end

#
# Create initial Show Templates
#
puts 'Create Show Templates'
[
  [ 2, 'Improv Labratory', get_time('18:30'), get_time('20:00'), %w(MC HM LS BO) ],
  [ 4, 'Unusual Suspects', get_time('18:30'), get_time('20:00'), %w(MC HM LS SS CS BO) ],
  [ 5, 'Friday Night Improv', get_time('19:30'), get_time('21:00'), %w(MC HM LS SS CS BO) ],
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


