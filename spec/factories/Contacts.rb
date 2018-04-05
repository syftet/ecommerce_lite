require 'faker'
FactoryBot.define do
  factory :contact do
      full_name Faker::Name.name
      email Faker::Internet.email
      phone Faker::PhoneNumber.phone_number
      inquiry_type "inquery"
      message "aaaaaaaa"
  end

  factory :InvalidContact do
    full_name Faker::Name.name
    email Faker::Internet.email
    phone Faker::PhoneNumber.phone_number
    inquiry_type "inquery"
    message "aaaaaaaa"
  end
end
