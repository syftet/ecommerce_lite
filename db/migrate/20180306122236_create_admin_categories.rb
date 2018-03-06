class CreateAdminCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_categories do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.string :permalink
      t.string :meta_title
      t.string :meta_desc
      t.string :keywords
      t.integer :parent_id

      t.timestamps
    end
  end
end
