# == Schema Information
#
# Table name: customer_returns
#
#  id                :integer          not null, primary key
#  number            :string(255)
#  stock_location_id :integer
#  order_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class CustomerReturn < ApplicationRecord
  belongs_to :order
  has_many :return_items

  accepts_nested_attributes_for :return_items, reject_if: lambda { |item| item[:returned] == "0" }
end
