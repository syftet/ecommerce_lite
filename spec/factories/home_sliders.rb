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

FactoryBot.define do
  factory :homeSlider do
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png') }
    title "This is title"
    sub_title "this is sub title"
  end
end

