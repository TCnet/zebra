# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "nbtcnet",
             email: "hxmusic@foxmail.com",
             password:              "111111",
             password_confirmation: "111111",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "xiangzi",
             email: "1160167250@qq.com",
             password:              "111111",
             password_confirmation: "111111",
             activated: true,
             activated_at: Time.zone.now)


users = User.order(:created_at).take(2)


  
