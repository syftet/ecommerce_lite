class ChangeColumnDefaultOfStockLocation < ActiveRecord::Migration[5.1]
  def change
    change_column_default :stock_locations, :propagate_all_variants, true
  end
end
