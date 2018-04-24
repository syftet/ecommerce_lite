class CreateCustomerReturns < ActiveRecord::Migration[5.1]
  def change
    create_table :customer_returns do |t|
      t.string :number
      t.integer :stock_location_id
      t.integer :order_id
      t.timestamps
    end
  end
end
