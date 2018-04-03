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

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
