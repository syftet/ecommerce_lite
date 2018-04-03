# == Schema Information
#
# Table name: rewards_points
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  points     :float(24)        default(0.0)
#  reason     :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RewardsPoint < ApplicationRecord
  belongs_to :user
  belongs_to :order
end
