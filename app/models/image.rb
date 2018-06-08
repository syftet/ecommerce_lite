# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  viewable_type :string(255)
#  viewable_id   :integer
#  width         :integer
#  height        :integer
#  file_size     :integer
#  position      :integer
#  content_type  :string(255)
#  file          :text(65535)
#  alt           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_images_on_viewable_type_and_viewable_id  (viewable_type,viewable_id)
#

class Image < ApplicationRecord
  belongs_to :viewable, polymorphic: true

  mount_uploader :file, Admin::ImageUploader
   validates_presence_of :file
end
