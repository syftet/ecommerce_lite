# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  amount            :decimal(10, )
#  order_id          :integer
#  payment_method_id :integer
#  state             :string(255)
#  response_code     :string(255)
#  response_message  :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Payment < ApplicationRecord
  include GenerateNumber
  extend FriendlyId
  friendly_id :number, slug_column: :number, use: :slugged

  belongs_to :order
  belongs_to :payment_method
  validates :payment_method, presence: true

  after_save :update_order

  validates :amount, numericality: true

  scope :checkout, -> { with_state('checkout') }
  scope :completed, -> { with_state('completed') }
  scope :pending, -> { with_state('pending') }
  scope :processing, -> { with_state('processing') }
  scope :failed, -> { with_state('failed') }

  def update_order
    if completed? || void?
      order.updater.update_payment_total
    end

    if order.completed?
      order.updater.update_payment_state
      order.updater.update_shipments
      order.updater.update_shipment_state
    end

    if self.completed? || order.completed?
      order.persist_totals
    end
  end

end
