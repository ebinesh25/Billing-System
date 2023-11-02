class BillProduct < ApplicationRecord
  belongs_to :bill
  belongs_to :product

  before_save :calculate_prices

  def calculate_prices
    product = self.product

    self.purchased_price = self.quantity * product.unit_price
    self.tax_payable = self.purchased_price * (product.tax_percent/100)
    self.total_price = self.purchased_price + self.tax_payable

  end

end
