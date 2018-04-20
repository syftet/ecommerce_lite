class AddUserIdToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :user_id, :integer
  end
end
