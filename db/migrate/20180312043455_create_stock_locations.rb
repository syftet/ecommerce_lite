class CreateStockLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :stock_locations do |t|
      t.string :name
      t.boolean :default, default: false
      t.string :address1
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.string :phone
      t.boolean :active, default: true
      t.boolean :backorderable_default, default: false
      t.boolean :propagate_all_variants, default: false
      t.string :admin_name

      t.timestamps
    end
  end
end
