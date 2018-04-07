FactoryBot.define do
  factory :admin_brand, class: Admin::Brand do
    name Faker:: Name.name
    description Faker::Lorem.sentence(20, false, 0).chop
  end
end
