class CreateAdminBrands < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_brands do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :permalink
      t.string :meta_title
      t.string :meta_desc
      t.string :keywords
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
