class AddSpecialInstructionsFieldsToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :special_instructions, :text
  end
end
