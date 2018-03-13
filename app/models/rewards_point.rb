class RewardsPoint < ApplicationRecord
  belongs_to :user
  belongs_to :order

  def available
    sum(:points)
  end
end
