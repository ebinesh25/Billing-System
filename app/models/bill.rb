class Bill < ApplicationRecord
  has_many :bill_products
  has_many :products, through: :bill_products
end
