class CreateStockTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_transfers do |t|
      t.string :transfer_type
      t.string :reference
      t.integer :source_location_id
      t.integer :destination_location_id
      t.string :number

      t.timestamps
    end
  end
end
