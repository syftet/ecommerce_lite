class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.numeric :amount
      t.integer :order_id
      t.integer :payment_method_id
      t.string :state
      t.string :response_code
      t.string :response_message

      t.timestamps
    end
  end
end
