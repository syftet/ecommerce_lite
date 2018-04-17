# == Schema Information
#
# Table name: shipping_methods
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  display_on   :string(255)
#  deleted_at   :datetime
#  admin_name   :string(255)
#  code         :string(255)
#  tracking_url :string(255)
#  rate         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


FactoryBot.define do
  factory :shipping_method do
    name "shipping method"
    display_on "display_on"
    admin_name  Faker::Name.name
    code  Faker::Code.asin
  end
end
