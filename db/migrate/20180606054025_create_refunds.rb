class CreateRefunds < ActiveRecord::Migration[5.1]
  def change
    create_table :refunds do |t|
      t.integer :payment_id
      t.numeric :amount
      t.string :reason
      t.timestamps
    end
  end
end
