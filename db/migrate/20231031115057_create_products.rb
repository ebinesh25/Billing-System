class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.decimal :unit_price
      t.float :tax_percent

      t.timestamps
    end
  end
end
