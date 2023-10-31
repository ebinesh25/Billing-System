class RenameBilledProductToBillProduct < ActiveRecord::Migration[7.0]
  def change
    rename_table :billed_products, :bill_products
  end
end
