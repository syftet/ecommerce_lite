# == Schema Information
#
# Table name: payment_methods
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  name        :string(255)
#  description :text(65535)
#  active      :boolean
#  preferences :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PaymentMethod < ApplicationRecord

  scope :active, -> { where(active: true) }
  scope :available, -> { active.where(display_on: [:front_end, :back_end, :both]) }

  validates :name, presence: true

  has_many :payments, class_name: "Payment", inverse_of: :payment_method

  def self.providers
    Rails.application.config.spree.payment_methods
  end

  def self.all_active
    self.where(active: true)
  end

  def provider_class
    raise ::NotImplementedError, 'You must implement provider_class method for this gateway.'
  end

  # The class that will process payments for this payment type, used for @payment.source
  # e.g. CreditCard in the case of a the Gateway payment type
  # nil means the payment method doesn't require a source e.g. check
  def payment_source_class
    raise ::NotImplementedError, 'You must implement payment_source_class method for this gateway.'
  end

  def method_type
    type.demodulize.downcase
  end

  def self.find_with_destroyed *args
    unscoped { find(*args) }
  end

  def payment_profiles_supported?
    false
  end

  def source_required?
    false
  end

  def type_name
    self.type.split('::').last
  end

  # Custom gateways should redefine this method. See Gateway implementation
  # as an example
  def reusable_sources(order)
    []
  end

  def auto_capture?
    self.auto_capture.nil? ? Syftet.config.auto_capture : self.auto_capture
  end

  def supports?(source)
    true
  end

  def cancel(response)
    raise ::NotImplementedError, 'You must implement cancel method for this payment method.'
  end

  def store_credit?
    self.class == PaymentMethod::StoreCredit
  end
end
