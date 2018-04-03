# == Schema Information
#
# Table name: home_sliders
#
#  id         :integer          not null, primary key
#  image      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string(255)
#  sub_title  :string(255)
#  link       :string(255)
#

class HomeSlider < ApplicationRecord
  mount_uploader :image, Admin::HomeSliderUploader
  validates_presence_of :image
end
