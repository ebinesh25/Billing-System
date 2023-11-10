# frozen_string_literal: true

class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.string :customer_email
      t.decimal :customer_amount

      t.timestamps
    end
  end
end
