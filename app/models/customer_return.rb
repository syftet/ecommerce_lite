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
  PREFIX = 'RT-'.freeze
  has_many :return_items
  belongs_to :stock_location
  include GenerateNumber
  accepts_nested_attributes_for :return_items, reject_if: lambda { |item| item[:returned] == "0" }

  after_create :create_refund


  def prefix
    CustomerReturn::PREFIX
  end


  def create_refund
    order.payments.first.refunds.create(amount: total_refund_amount, reason: 'Customer Returns')
  end

  def total_refund_amount
    sum = 0
    return_items.each do |va|
      sum =  sum + va.line_item.price
    end
    sum
  end
end
