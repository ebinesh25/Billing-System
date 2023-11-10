# spec/models/bill_spec.rb

require 'rails_helper'

RSpec.describe Bill, type: :model do
  let(:customer_email) { 'test@example.com' }
  let(:bill) { Bill.create(customer_email: customer_email, customer_amount: 100.0) }

  subject { bill }

  describe '#calculate_balance_to_customer' do
    let!(:bill_product_1) { bill.bill_products.create(purchased_price: 30.0, tax_payable: 5.0) }
    let!(:bill_product_2) { bill.bill_products.create(purchased_price: 50.0, tax_payable: 8.0) }

    it 'calculates the balance amount to the customer' do
      total_price_without_tax = 80.0
      total_tax_payable = 13.0
      net_price = 93.0
      rounded_price = 93
      balance_amount = 7.0

      result = bill.calculate_balance_to_customer

      expect(result["Total Price Without Tax"]).to eq(total_price_without_tax)
      expect(result["Total Tax Payable"]).to eq(total_tax_payable)
      expect(result["Net Price"]).to eq(net_price)
      expect(result["Rounded Price"]).to eq(rounded_price)
      expect(result["Balance amount to customer"]).to eq(balance_amount)
    end

    context 'when customer_amount is less than the total price' do
      let(:bill) { Bill.create(customer_email: customer_email, customer_amount: 50.0) }
      let!(:bill_product) { bill.bill_products.create(purchased_price: 60.0, tax_payable: 10.0) }

      it 'handles the scenario' do
        result = bill.calculate_balance_to_customer
        expect(result["Balance amount to customer"]).to be < 0
      end
    end
  end
end
