# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#
# Create Configs
#
puts 'Create Configuration'
{
    'MemberMaxConflicts'  => [ 4,   'The maximum number of conflicts a Member is allowed in a given month.'      ],
    'MemberMinShifts'     => [ 3,   'The minimum number of shifts each Member will be [auto]assigned per month.' ],
    'MemberMaxShifts'     => [ 4,   'The maximum number of shifts each Member will be [auto]assigned per month.' ],
    'CastMinShows'        => [ 5,   'The minimum number of shows a full-cast member is expected to perform in.'  ],
    'DefaultShowCapacity' => [ 123, 'The default capacity for Shows.'                                            ]
}.each do |key, value|
  record = Konfig.where(name: key).first_or_create
  if record.new_record?
    puts "Adding #{key}"
    record.update_attributes(value: value[0], desc: value[1])
  end
end

#
# Create Roles
#
# Cast:  Can this Role be cast in shows?
# Crew:  Can this Role man Shifts?
# cm:    Is this Role considered a "Company Member"?
# Sched: Should this role be included in auto-scheduling?
#
puts 'Create Roles'
#     Role         Cast?  Crew?  cm?    Sched? Title                  Description
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
      confirmed_at: Time.now,
      notes: [note]
  )

  unless admin.valid?
    puts 'Could not create Admin Account!'
    puts admin.errors.messages.to_s
    exit
  end

  admin.add_role :admin
end

if Member.joins(:roles).where('roles.name' => 'apprentice').empty?
  puts 'Create Apprentice account'
  note  = Note.new(content: 'This is a temporary Apprentice account, used to test apprentice view.  Please remove when possible.')
  apprentice = Member.create(
      firstname: 'Apprentice',
      lastname:  'Apprentice',
      email:    'apprentice@example.com',
      password: 'apprentice4wwit',
      password_confirmation: 'apprentice4wwit',
      confirmed_at: Time.now,
      notes: [note]
  )

  unless apprentice.valid?
    puts 'Could not create Apprentice Account!'
    puts apprentice.errors.messages.to_s
    exit
  end

  apprentice.add_role :apprentice
end

if Member.joins(:roles).where('roles.name' => 'staff').empty?
  puts 'Create Staff account'
  note  = Note.new(content: 'This is a temporary staff account, used to test staff view.  Please remove when possible.')
  staff = Member.create(
      firstname: 'Staff',
      lastname:  'Staff',
      email:    'staff@example.com',
      password: 'staff4wwit',
      password_confirmation: 'staff4wwit',
      confirmed_at: Time.now,
      notes: [note]
  )

  unless staff.valid?
    puts 'Could not create Staff Account!'
    puts staff.errors.messages.to_s
    exit
  end

  staff.add_role :staff
end
