class AddColumnPosIdToImages < ActiveRecord::Migration[5.1]
  def change
    add_column :images, :pos_id, :integer
  end
end
