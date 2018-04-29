# == Schema Information
#
# Table name: stock_locations
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  default                :boolean          default(FALSE)
#  address                :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  zipcode                :string(255)
#  country                :string(255)
#  phone                  :string(255)
#  active                 :boolean          default(TRUE)
#  backorderable_default  :boolean          default(FALSE)
#  propagate_all_variants :boolean          default(TRUE)
#  admin_name             :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

#  id                     :integer          not null, primary key
#  name                   :string(255)
#  default                :boolean          default(FALSE)
#  address                :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  zipcode                :string(255)
#  country                :string(255)
#  phone                  :string(255)
#  active                 :boolean          default(TRUE)
#  backorderable_default  :boolean          default(FALSE)
#  propagate_all_variants :boolean          default(TRUE)
#  admin_name             :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
FactoryBot.define do
  factory :stock_location do
    name "stockLocation"
    address1 Faker::Address.state
    city Faker::Address.city
    state Faker::Address.state
    zipcode Faker::Address.zip_code
    country Faker::Address.country
    phone Faker::PhoneNumber.phone_number
    active true
  end
end
