# == Schema Information
#
# Table name: stock_movements
#
#  id              :integer          not null, primary key
#  stock_item_id   :integer
#  quantity        :integer          default(0)
#  action          :string(255)
#  originator_id   :integer
#  originator_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :stock_movement do
    
  end
end
