class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.string :name
      t.string :email
      t.string :feedback_type
      t.text :message
      t.string :product_quality
      t.string :product_price
      t.text :customer_service
      t.integer :rate

      t.timestamps
    end
  end
end
