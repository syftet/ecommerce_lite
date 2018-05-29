class AddSourceIdFieldToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :source_id, :integer
    add_column :payments, :source_type, :string
  end
end
