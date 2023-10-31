class ChangeProductIdToStringInBillProducts < ActiveRecord::Migration[7.0]
  def change
    reversible do |direction|
        direction.up   { change_column :billed_products, :product_id, :string }
        direction.down { change_column :billed_products, :product_id, :string }

    end
  end
end
