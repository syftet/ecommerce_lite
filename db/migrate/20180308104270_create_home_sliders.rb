class CreateHomeSliders < ActiveRecord::Migration[5.1]
  def change
    create_table :home_sliders do |t|
      t.string :image

      t.timestamps
    end
  end
end
