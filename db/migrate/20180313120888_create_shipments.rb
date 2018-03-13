class CreateShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :shipments do |t|
      t.string :tracking
      t.string :number
      t.numeric :cost, default: 0
      t.datetime :shipped_at
      t.integer :order_id
      t.integer :address_id
      t.string :state
      t.integer :stock_location_id
      t.numeric :adjustment_total, default: 0
      t.numeric :promo_total, default: 0

      t.timestamps
    end
  end
end
