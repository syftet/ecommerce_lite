class AddColumnTrackInventoryToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :track_inventory, :boolean, default: true
  end
end
