class CreateLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :line_items do |t|
      t.integer :variant_id
      t.integer :order_id
      t.integer :quantity
      t.float :price, default: 0
      t.float :cost_price, default: 0
      t.string :currency
      t.numeric :adjustment_total, default: 0
      t.numeric :promo_total, default: 0
      t.string :size

      t.timestamps
    end
  end
end
