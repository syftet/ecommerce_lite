class AddColumnPosIdToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :pos_id, :integer
  end
end
