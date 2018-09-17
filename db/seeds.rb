# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Category.create!(name:  "Laptop",
                parent_id: 0)
Category.create!(name:  "Mobile phone",
                parent_id: 0)
Category.create!(name:  "Other",
                parent_id: 0)
Category.create!(name:  "Dell",
                parent_id: 1)
Category.create!(name:  "Assus",
                parent_id: 1)
Category.create!(name:  "Lenovo",
                parent_id: 1)
Category.create!(name:  "Samsung",
                parent_id: 2)
Category.create!(name:  "Iphone",
                parent_id: 2)
Category.create!(name:  "HTC",
                parent_id: 2)
3.times do |n|
  name  = "Dell#{n}"
  Category.create!(name:  name,
                parent_id: 4)
end
3.times do |n|
  name  = "Assus#{n}"
  Category.create!(name:  name,
                parent_id: 5)
end
3.times do |n|
  name  = "Lenovo#{n}"
  Category.create!(name:  name,
                parent_id: 6)
end
3.times do |n|
  name  = "Samsung#{n}"
  Category.create!(name:  name,
                parent_id: 7)
end
3.times do |n|
  name  = "Iphone#{n}"
  Category.create!(name:  name,
                parent_id: 8)
end
3.times do |n|
  name  = "HTC#{n}"
  Category.create!(name:  name,
                parent_id: 9)
end

5.times do |n|
  name  = Faker::Name.name
  Category.create!(name:  name,
                parent_id: 3)
end

# 5.times do |n|
#   name  = Faker::Name.name
#   Category.create!(name:  name,
#                 parent_id: rand(3..8))
# end

50.times do |n|
  name  = Faker::Name.name
  content = Faker::Lorem.sentence(5)
  Product.create!(name:  name,
               price: rand(50..10000),
               quantity: rand(5..30),
               description: content,
               picture: "default.png",
               category_id: rand(10..23))
end
User.create!(name:  "phuoctuyen",
             email: "haphuoctuyen1997@gmail.com",
             password: "11111111",
             password_confirmation: "11111111",
             address: "điện phước ,điện bàn , quảng nam",
             phone: "01219399936"
             )

User.create!(name:  "duongtruong",
             email: "duongtruong@gmail.com",
             password: "foobar",
             password_confirmation: "foobar",
             role: 1,
             address: "fdsfdsfdsfdsfdsfsdasdsad",
             phone: "3454343242"
             )

User.create!(name:  "vanle",
             email: "phamvanle@gmail.com",
             password: "123123",
             password_confirmation: "123123",
             role: 1,
             address: "quang nam",
             phone: "01667272741"
             )

10.times do |n|
  name  = Faker::Name.name
  email = "example_#{n}@gmail.com"
  password = "123123"
  content = Faker::Lorem.sentence(5)
  User.create!(name:  name,
               email: email,
               password: password,
               password_confirmation: password,
               role: 0,
               address: content,
               phone: "01667272741")
end

p "Created #{User.count} users"

10.times do |n|
  name  = Faker::Name.name
  content = Faker::Lorem.sentence(5)
  Order.create!(user_id: rand(1..3),
               receiver_name:  name,
               receiver_address: content,
               receiver_phone: "01667272741",
               total_price: rand(100..10000))

end

10.times do |n|
  OrderItem.create!(order_id: rand(1..10),
                   product_id:  rand(1..10),
                   price: rand(50..1000),
                   quantity: rand(1..5))

end

10.times do |n|
  Comment.create!(content: "san pham tot",
                  user_id: rand(1..3),
                  product_id: rand(1..10))

end

# # Category.create!(name:  "cccccccccccc",
# #              parent_id: 1
# #              )
# p "Created #{Category.count} categoriess"

Suggest.create!(name:  "San pham moi",
             description: "San pham hot",
             status: 1,
             user_id: 1,
             category_id: 10
             )
p "Created #{Suggest.count} suggets"
