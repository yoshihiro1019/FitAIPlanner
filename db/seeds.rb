# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
10.times do
    User.create!(last_name: Faker::Name.last_name,
                first_name: Faker::Name.first_name,
                email: Faker::Internet.unique.email,
                password: "password",
                password_confirmation: "password")
  end
  
  user_ids = User.ids
  
  20.times do |index|
    user = User.find(user_ids.sample)
    user.boards.create!(title: "タイトル#{index}", body: "本文#{index}")
  end