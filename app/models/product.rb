class Product < ApplicationRecord
  # has_one :bill_product
  # has_one :bill, through: :bill_product
  has_many :bill_products
  has_many :bills, through: :bill_products
end
