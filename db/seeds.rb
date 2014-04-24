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
dist_centres = [["Auckland",-36.8484597,174.76333150000005],
["Hamilton",-37.7870012,175.27925300000004],
["Rotorua",-38.1368478,176.24974610000004],
["Palmerston North",-40.3523065,175.60821450000003],
["Wellington",-41.2864603,174.77623600000004],
["Christchurch",-43.5320544,172.63622540000006],
["Dunedin",-45.8787605,170.5027976]]

dist_centres.each do |c|
  Place.create(name: c[0], lat: c[1], lon: c[2], new_zealand: true)
end

countries = []

File.open('db/countries.csv').each do |line|
  row = line.split(",")
  countries.push [(row[3].gsub "\"", "").strip, row[1], row[2]]
end

countries.each do |c|
  Place.create(name: c[0], lat: c[1], lon: c[2], new_zealand: false)
end
