# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
# Character.create(name: "Luke", movie: movies.first)

require 'faker'
require 'open-uri'

Category.create(category_name: "Men")
Category.create(category_name: "Women")
Category.create(category_name: "Children")

Subcategory.create(subcategory_name: "Suits", category_id: 1)
Subcategory.create(subcategory_name: "Jeans", category_id: 1)
Subcategory.create(subcategory_name: "Shoes", category_id: 2)
Subcategory.create(subcategory_name: "Tops", category_id: 2)
Subcategory.create(subcategory_name: "Tshirts", category_id: 3)
Subcategory.create(subcategory_name: "Slippers", category_id: 3)

10.times do
  product_name = Faker::Commerce.unique.product_name
  category_id = Faker::Number.between(from: 1, to: 3)
  subcategory_id = Faker::Number.between(from: 1, to: 6)
  price =  Faker::Number.decimal(l_digits: 3, r_digits: 2)
  material = Faker::Commerce.material
  vendor = Faker::Commerce.vendor
  description = Faker::Lorem.words(number: rand(2..10)).join(' ')
  stock_quantity = Faker::Number.between(from: 1, to: 10)
  shipping_fees = Faker::Number.decimal(l_digits: 2, r_digits: 2)
  tax =  Faker::Number.decimal(l_digits: 1, r_digits: 2)
  product = Product.create(product_name: product_name, category_id: category_id,
    subcategory_id: subcategory_id, price: price, material: material, 
    vendor: vendor, description: description, stock_quantity: stock_quantity,
    shipping_fees: shipping_fees, tax: tax)
  2.times do
    image = URI.open(Faker::LoremFlickr.image(size: "50x60"))
    product.images.attach({io: image, filename: "faker_image.jpg"})
  end
end
AdminUser.create!(email: 'admin@ekart.com', password: 'password', password_confirmation: 'password') if Rails.env.development?