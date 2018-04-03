# == Schema Information
#
# Table name: blogs
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  body        :text(65535)
#  user_id     :integer
#  cover_photo :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Blog < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  mount_uploader :cover_photo, Admin::BlogCoverPhotoUploader
  has_many :comments
  
  validates_presence_of :title, :body, :cover_photo
end
