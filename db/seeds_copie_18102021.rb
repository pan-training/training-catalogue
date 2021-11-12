# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Roles
puts "\nSeeding roles"
Role.create_roles

# Default user
puts "\nSeeding default user"
User.get_default_user

# Nodes
puts "\nSeeding nodes"
path = File.join(Rails.root, 'config', 'data', 'elixir_nodes.json')
hash = JSON.parse(File.read(path))
Node.load_from_hash(hash, verbose: false)

puts "Done"

  user=User.new(
    username: "sockse",
    email: "meadress@mail.com",
    password: "Reeeeeeeeeeeeeeeeeeeee3",
    processing_consent:'1'
  )
  user.save!

#1000.times do
10.times do
  user=User.new(
    username: Faker::Internet.unique.user_name,
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    processing_consent:'1',
    created_at:Faker::Date.between(from: 400.days.ago, to: Date.today)
  )
  user.save!
end




resource_types = ["Document", "Video", "Tutorial", "Wiki", "Moodle course", "Software"]

licences = ["Creative Commons Attribution 4.0", "Educational Community License 2.0","EU DataGrid Software License","Fair License","MIT License"]

#users = User.order(:created_at).take(6)


users = User.limit(5).order("RANDOM()")

2.times do
  url = Faker::Internet.url
  keyword = Faker::Science.science 
  puts keyword
  puts "calll meeeeeeeeeeee"
  title = Faker::Lorem.sentence(word_count: 3)
  puts title
  puts "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
  #short_description = Faker::Lorem.sentences(number: 1)
  short_description =Faker::Lorem.sentence(word_count: 10)
  authors = [Faker::Name.name,Faker::Name.name]
  licence = licences.sample
  resource_type = resource_types.sample
  #keywords = []
  #users.each { |user| user.diaries.create!(content: body) }
  users.each { |user| user.materials.create!(url:url,keyword:keyword,title:title,short_description:short_description,authors:authors,resource_type:resource_type) }
end




