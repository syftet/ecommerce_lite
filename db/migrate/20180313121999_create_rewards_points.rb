class CreateRewardsPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :rewards_points do |t|
      t.integer :order_id
      t.float :points, default: 0
      t.string :reason
      t.integer :user_id

      t.timestamps
    end
  end
end
