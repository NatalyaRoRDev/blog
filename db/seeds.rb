User.create!(name:  "Наталья",
             age: '34',
             city: 'Moscow',
             email: "ruby_developer1@yahoo.com",
             password:              "Lina96MyFriend$",
             password_confirmation: "Lina96MyFriend$",
             admin: true)

5.times do |n|
  name  = Faker::Name.name
  age = '25'
  city = 'Moskow'
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!(name:  name,
               age: age,
               city: city,
               email: email,
               password:              password,
               password_confirmation: password)
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
