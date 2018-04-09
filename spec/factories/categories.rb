FactoryBot.define do
  factory :category, class: Admin::Category do
    name Faker::Name.name
    description "this is description"
  end
end
