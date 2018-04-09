FactoryBot.define do
  factory :image do
   width 10
    height 10
    file_size 30
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png') }
  end
end
