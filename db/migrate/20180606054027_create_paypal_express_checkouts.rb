class CreatePaypalExpressCheckouts < ActiveRecord::Migration[5.1]
  def change
    create_table :paypal_express_checkouts do |t|
      t.string :token
      t.string :payer_id
      t.integer :order_id
      t.string :state, default: 'completed'
      t.integer :refund_id
      t.datetime :refunded_at
      t.string :refund_type

      t.timestamps
    end
  end
end
