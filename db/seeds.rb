# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

%w[ Mobile_phone Dress Tablet PC Laptop ].each do |product|
  Product.create!(name: product, unit_price: SecureRandom.random_number(1000), tax_percent: SecureRandom.random_number.round(4)*100)
end