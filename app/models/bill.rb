class Bill < ApplicationRecord
  has_many :bill_products, dependent: :destroy
  has_many :products, through: :bill_products

  attr_accessor :denominations

  accepts_nested_attributes_for :bill_products, allow_destroy: true
  #By default you can only create and update but can't delete allow_destroy allows to destroy the record
end
