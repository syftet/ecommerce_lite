# == Schema Information
#
# Table name: refunds
#
#  id         :integer          not null, primary key
#  payment_id :integer
#  amount     :decimal(10, )
#  reason     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :refund do
    
  end
end
