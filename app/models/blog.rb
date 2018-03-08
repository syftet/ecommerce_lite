class Blog < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  mount_uploader :cover_photo, Admin::BlogCoverPhotoUploader
  has_many :comments
  
  validates_presence_of :title, :body, :cover_photo
end