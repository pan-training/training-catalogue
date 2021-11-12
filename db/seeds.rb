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


if Rails.env.development?

  user=User.new(
    username: "sockse",
    email: "meadress@mail.com",
    password: "Reeeeeeeeeeeeeeeeeeeee3",
    processing_consent:'1'
  )
  user.save!

#1000.times do
100.times do
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


users = User.limit(20).order("RANDOM()")

#2.times do


  for i in users do
    nombre_random = rand(1..10)
    compteur=0
    while compteur < nombre_random
    url = Faker::Internet.url
    keyword = Faker::Science.science 
    keywords = [Faker::Science.science,Faker::Science.science]
    puts keyword
    title = Faker::Lorem.sentence(word_count: 3)
    puts title
    #short_description = Faker::Lorem.sentences(number: 1)
    short_description =Faker::Lorem.sentence(word_count: 10)
    #authors = [Faker::Name.name,Faker::Name.name]
    licence = licences.sample
    resource_type = [resource_types.sample]
    #i.materials.create!(url:url,keywords:keywords,title:title,short_description:short_description,authors:authors,resource_type:resource_type)
    i.materials.create!(url:url,keywords:keywords,title:title,short_description:short_description,resource_type:resource_type)
    compteur+=1
    end
  end


#end



  event=Event.new(
    title: "hyallu",
    url: "https://www.google.com",
    latitude: 24.61795, 
    longitude: 119.67348,
    user_id:2)
  event.save!
  
end
