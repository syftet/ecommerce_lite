class AddFieldsToHomeSlider < ActiveRecord::Migration[5.1]
  def change
    add_column :home_sliders, :title, :string
    add_column :home_sliders, :sub_title, :string
    add_column :home_sliders, :link, :string
  end
end
