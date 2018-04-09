FactoryBot.define do
  factory :homeSlider do
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png') }
    title "This is title"
    sub_title "this is sub title"
  end
end

