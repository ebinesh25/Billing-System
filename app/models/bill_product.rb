class BillProduct < ApplicationRecord
  belongs_to :bill
  belongs_to :product

  before_save :calculate_prices

  validates :product_id, presence: true, uniqueness: { scope: :bill_id, message: "You can enter product only once"}
  validates :quantity, presence: true, numericality: true

  def calculate_prices
    self.purchased_price = quantity * product.unit_price
    self.tax_payable = purchased_price * (product.tax_percent/100)
    self.total_price = purchased_price + tax_payable
  end

end
