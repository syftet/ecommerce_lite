class CreateStockItems < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_items do |t|
      t.integer :stock_location_id
      t.integer :product_id
      t.integer :count_on_hand, default: 0
      t.boolean :backorderable, default: false
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
