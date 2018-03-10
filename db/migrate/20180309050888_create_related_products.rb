class CreateRelatedProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :related_products do |t|
      t.integer :product_id
      t.integer :relative_id

      t.timestamps
    end
  end
end
