class ChangeForeignKeyIdToStringInBillProduct < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up {change_column :bill_products, :product_id, :string }
      dir.down {change_column :bill_products, :product_id, :integer }
    end
  end
end
