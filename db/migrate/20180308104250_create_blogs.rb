class CreateBlogs < ActiveRecord::Migration[5.1]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.string :cover_photo
      t.string :slug

      t.timestamps
    end
  end
end
