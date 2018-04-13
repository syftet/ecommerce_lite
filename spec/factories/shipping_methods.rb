
FactoryBot.define do
  factory :shipping_method do
    name "shipping method"
    display_on "display_on"
    admin_name  Faker::Name.name
    code  Faker::Code.asin
  end
end
