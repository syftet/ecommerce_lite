class HomeSlider < ApplicationRecord
  mount_uploader :image, Admin::HomeSliderUploader
  validates_presence_of :image
end
