class AddCollectionPointToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :collection_point, :string
  end
end
