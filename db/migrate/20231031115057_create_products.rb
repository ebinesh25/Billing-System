# frozen_string_literal: true

require 'securerandom'

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products,id: false ,primary_key: %i[custom_id] do |t|
      t.string :name, null: false
      t.string :id, primary_key: true
      t.decimal :unit_price, null: false
      t.float :tax_percent, null: false
      t.timestamps
    end
  end


end
