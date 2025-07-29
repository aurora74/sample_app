# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create a main sample user (admin)
User.create!(name: "Admin",
             email: "admin@gmail.com",
             password: "123123",
             password_confirmation: "123123",
             birthday: 25.years.ago,
             gender: "male",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  birthday = Faker::Date.birthday(min_age: 18, max_age: 80)
  gender = %w(male female other).sample
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               birthday: birthday,
               gender: gender,
               activated: true,
               activated_at: Time.zone.now)
end

# Create sample microposts
Micropost.create!(content: "First micropost! Hello world!")
Micropost.create!(content: "Learning Ruby on Rails is awesome!")
Micropost.create!(content: "This is my third micropost. Building a sample app.")
Micropost.create!(content: "Rails makes web development fun and easy!")
Micropost.create!(content: "Just finished implementing the microposts feature!")
