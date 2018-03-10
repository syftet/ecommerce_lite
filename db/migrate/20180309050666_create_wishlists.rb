class CreateWishlists < ActiveRecord::Migration[5.1]
  def change
    create_table :wishlists do |t|
      t.integer :product_id
      t.integer :user_id

      t.timestamps
    end
  end
end
