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

FactoryBot.define do
  factory :image do
   width 10
    height 10
    file_size 30
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png') }
  end
end
