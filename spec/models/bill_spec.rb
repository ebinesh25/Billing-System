require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe Testing Associations do
    it "should have many products" do
      t = Bill.reflect_on_association(:products)
      expect(t.macro).to eq(:has_many)
    end
    it "should have many products through bill_products" do
      t = Bill.reflect_on_association(:products)
      expect(t.macro).to eq({:through => :bill_products})
    end
  end
end
