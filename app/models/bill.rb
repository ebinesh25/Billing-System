class Bill < ApplicationRecord
  has_many :bill_products, dependent: :destroy
  has_many :products, through: :bill_products

  attr_accessor :denominations

  accepts_nested_attributes_for :bill_products, allow_destroy: true
  #By default you can only create and update but can't delete allow_destroy allows to destroy the record

  def remaining_denominations
    self.denominations.each do |_, denoms|
      denoms.each do |denom, _|
      # count = self.customer_amount / denom.to_i
        count = self.customer_amount.div(denom.to_i) #Does floor division
        if count > 0
          denoms[denom] = denoms[denom].to_i - count
          self.customer_amount  %= denom.to_i
        end
      end
    end

    denominations
  end

end
