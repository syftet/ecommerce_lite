class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :code, null: false
      t.string :name
      t.text :description
      t.string :origin
      t.string :slug
      t.string :meta_title
      t.text :meta_desc
      t.string :keywords
      t.references :brand
      t.boolean :is_featured, default: false, null: false
      t.boolean :is_active, default: true, null: false
      t.datetime :deleted_at
      t.integer :product_id
      t.float :sale_price, default: 0.0, null: false
      t.float :cost_price, default: 0.0, null: false
      t.float :whole_sale, default: 0.0, null: false
      t.string :color_name
      t.string :color
      t.string :size
      t.string :weight
      t.string :width
      t.string :height
      t.string :depth
      t.boolean :discountable, default: false
      t.boolean :is_amount, default: false
      t.float :discount, default: 0.0, null: false
      t.float :reward_point, default: 0.0, null: false

      t.timestamps
    end

    change_column :products, :sale_price, :double
    change_column :products, :cost_price, :double
    change_column :products, :whole_sale, :double
    change_column :products, :discount, :double
    change_column :products, :reward_point, :double
  end
end
