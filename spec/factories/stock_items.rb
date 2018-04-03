# == Schema Information
#
# Table name: stock_items
#
#  id                :integer          not null, primary key
#  stock_location_id :integer
#  product_id        :integer
#  count_on_hand     :integer          default(0)
#  backorderable     :boolean          default(FALSE)
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryBot.define do
  factory :stock_item do
    product_id 10
    stock_location
  end

  factory :stock_location do
    name 'apon'
  end
end
