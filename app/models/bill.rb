# frozen_string_literal: true

class Bill < ApplicationRecord
  has_many :bill_products, dependent: :destroy
  has_many :products, through: :bill_products
  accepts_nested_attributes_for :bill_products, allow_destroy: true, reject_if: :all_blank
  # By default you can only create and update but can't delete allow_destroy allows to destroy the record

  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :customer_amount, presence: true

  def calculate_balance_to_customer
    total_price_without_tax = bill_products.sum(:purchased_price).round(2)
    total_tax_payable = bill_products.sum(:tax_payable).round(2)
    net_price = (total_price_without_tax + total_tax_payable).round(2)
    rounded_price = net_price.floor
    balance_amount = customer_amount - rounded_price

    update_columns(total_price_without_tax:,
                   total_tax_payable:,
                   net_price:,
                   rounded_price:,
                   balance_amount:)
    # {
    #   "Total Price Without Tax": total_price_without_tax,
    #   "Total Tax Payable": total_tax_payable,
    #   "Net Price": net_price,
    #   "Rounded Price": rounded_price,
    #   "Balance amount to customer": balance_amount
    # }
    puts " #{{
      "Total Price Without Tax": total_price_without_tax,
      "Total Tax Payable": total_tax_payable,
      "Net Price": net_price,
      "Rounded Price": rounded_price,
      "Balance amount to customer": balance_amount
    }}"
    puts '====================================================== BALANCE CALCULATED +++++++++++++++++++++++++++++++++++++++++++++'
  end
end
