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

class Refund < ApplicationRecord
  belongs_to :payment
  before_create :check_payment_amount



  private

  def check_payment_amount
    p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<,"
    p self.inspect
    p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<,"
    payment = Payment.find_by_id(payment_id)
    refund = payment.refunds.sum(:amount)
    total_refund = refund + amount
    if payment.amount < total_refund
      errors[:base] << "Refund amount must be less than or equal payment amount"
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end
end
