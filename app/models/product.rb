class Product < ApplicationRecord

  has_many :bill_products, dependent: :destroy
  has_many :bills, through: :bill_products
end
