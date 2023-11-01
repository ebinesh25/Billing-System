class BillProduct < ApplicationRecord
  belongs_to :bill
  belongs_to :product

  # accepts_nested_attributes_for :product
end
