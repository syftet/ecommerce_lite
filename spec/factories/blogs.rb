FactoryBot.define do
  factory :blog do
       title Faker::Lorem.sentence
       body Faker::Lorem.paragraph
  end
end