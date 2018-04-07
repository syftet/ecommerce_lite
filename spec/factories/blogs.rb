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

FactoryBot.define do
  factory :blog do
    title  "This is title"
    body "this is body"
    cover_photo { Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png') }
  end
end
