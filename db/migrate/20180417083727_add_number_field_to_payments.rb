class AddNumberFieldToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :number, :string
  end
end
