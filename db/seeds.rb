# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

phone = Phone.new(ntype: 'Mobile', number: '4049393709')
Member.create(
    username: 'dyoung',
    password: 'wwit4admin',
    password_confirmation: 'wwit4admin',
    email:    'dyoung522@gmail.com',
    firstname: 'Donovan',
    lastname:  'Young',
    phones: [phone]
)
