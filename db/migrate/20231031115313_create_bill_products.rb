# frozen_string_literal: true

class CreateBillProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :bill_products do |t|
      t.integer :quantity, null: false
      t.decimal :purchased_price, null: false
      t.decimal :tax_payable, null: false
      t.decimal :total_price, null: false
      t.references :bill, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
