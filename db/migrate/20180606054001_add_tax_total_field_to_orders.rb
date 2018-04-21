class AddTaxTotalFieldToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :tax_total, :decimal, default: 0
  end
end
