class AddColumnsToBill < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :total_price_without_tax, :decimal
    add_column :bills, :total_tax_payable, :decimal
    add_column :bills, :net_price, :decimal
    add_column :bills, :rounded_price, :decimal
    add_column :bills, :balance_amount, :decimal
  end
end
