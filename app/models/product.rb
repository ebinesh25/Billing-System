# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :bill_products, dependent: :destroy
  has_many :bills, through: :bill_products

  before_save :add_custom_id

  validates :name, :unit_price, :tax_percent, presence: true



  def add_custom_id
    puts "In Before save"
    # update_column(custom_id: "PID_#{SecureRandom.random_number(100000)}")
    self.id = "#{name.first(3)}_#{SecureRandom.random_number(100000)}"
  end
end
