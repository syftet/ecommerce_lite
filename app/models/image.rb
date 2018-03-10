class Image < ApplicationRecord
  belongs_to :viewable, polymorphic: true

  mount_uploader :file, Admin::ImageUploader
end
