# frozen_string_literal: true

class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.string :customer_email, null: false
      t.decimal :customer_amount, null: false

      t.timestamps
    end
  end
end
