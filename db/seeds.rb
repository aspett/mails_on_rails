# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

User.create(username: "Manager", password: "manager", password_confirmation: "manager", role: "Manager")
User.create(username: "Clerk", password: "clerk", password_confirmation: "clerk", role: "Clerk")

dist_centres = ["Auckland", "Hamilton", "Rotorua", "Palmerston North", "Wellington", "Christchurch", "Dunedin"]

dist_centres.each do |c|
  Place.create(name: c, new_zealand: true)
end

File.open('db/countries.txt').each do |line|
  Place.create(name: line.strip, new_zealand: false)
end

