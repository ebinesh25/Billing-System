# frozen_string_literal: true

class CreateBilledProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :billed_products do |t|
      t.integer :quantity
      t.decimal :purchased_price
      t.decimal :tax_payable
      t.decimal :total_price
      t.references :bill, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
