class CreateStockMovements < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_movements do |t|
      t.integer :stock_item_id
      t.integer :quantity, default: 0
      t.string :action
      t.integer :originator_id
      t.string :originator_type

      t.timestamps
    end
  end
end
