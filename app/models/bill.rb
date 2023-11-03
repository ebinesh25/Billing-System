class Bill < ApplicationRecord
  has_many :bill_products, dependent: :destroy
  has_many :products, through: :bill_products
  accepts_nested_attributes_for :bill_products, allow_destroy: true, reject_if: :all_blank
  #By default you can only create and update but can't delete allow_destroy allows to destroy the record

  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_amount, presence: true

  def calculate_balance_to_customer
    total_price_without_tax = bill_products.sum(:purchased_price)
    total_tax_payable = bill_products.sum(:tax_payable)
    net_price = total_price_without_tax + total_tax_payable
    rounded_price = net_price.round(2)
    balance_amount = customer_amount - rounded_price

    {
      "Total Price Without Tax": total_price_without_tax,
      "Total Tax Payable": total_tax_payable,
      "Net Price": net_price,
      "Rounded Price": rounded_price,
      "Balance amount to customer": balance_amount
    }


  end

end
