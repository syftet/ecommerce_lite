# == Schema Information
#
# Table name: shipments
#
#  id                 :integer          not null, primary key
#  tracking           :string(255)
#  number             :string(255)
#  cost               :decimal(10, )    default(0)
#  shipped_at         :datetime
#  order_id           :integer
#  address_id         :integer
#  state              :string(255)
#  stock_location_id  :integer
#  adjustment_total   :decimal(10, )    default(0)
#  promo_total        :decimal(10, )    default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  shipping_method_id :integer
#

FactoryBot.define do
  factory :shipment do
    
  end
end
