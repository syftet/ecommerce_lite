class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.string :name
      t.integer :rating
      t.text :text
      t.integer :product_id
      t.integer :user_id
      t.string :email
      t.boolean :is_approved, default: false

      t.timestamps
    end
  end
end
