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
#  number            :string(255)
#  source_id         :integer
#  source_type       :string(255)
#

class Payment < ApplicationRecord
  PREFIX = 'PY-'
  include GenerateNumber
  extend FriendlyId
  friendly_id :number, slug_column: :number, use: :slugged

  belongs_to :order
  belongs_to :payment_method
  validates :payment_method, presence: true
  has_many :refunds

  # after_save :update_order

  validates :amount, numericality: true

  scope :checkout, -> { with_state('checkout') }
  scope :completed, -> { with_state('completed') }
  scope :pending, -> { with_state('pending') }
  scope :processing, -> { with_state('processing') }
  scope :failed, -> { with_state('failed') }

  def update_order

    if order.completed?
      order.updater.update_payment_state
      order.updater.update_shipments
      order.updater.update_shipment_state
    end

    if self.completed? || order.completed?
      order.persist_totals
    end
  end

  def actions
    if self.state == 'captured'
      ['refund']
    elsif self.state == 'void'
      []
    else
      ['capture', 'void',]
    end
  end

  def captured?
    self.state == 'captured'
  end

  def void?
    self.state == 'void'
  end

  def prefix
    Payment::PREFIX
  end

  def capture!(capture_amount = nil)
    return true if captured?
    payment_method.capture(self)
  end

  def void_transaction!
    return true if void?
    payment_method.void(self)
  end

end
