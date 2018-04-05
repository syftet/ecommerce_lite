FactoryBot.define do
  factory :blog do
    title  "This is title"
    body "this is body"
    cover_photo { Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png') }
  end
end
