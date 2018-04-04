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

class PaymentMethod::Check < PaymentMethod
  def actions
    %w{capture void}
  end

  # Indicates whether its possible to capture the payment
  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end

  # Indicates whether its possible to void the payment.
  def can_void?(payment)
    payment.state != 'void'
  end

  def capture(*)
    simulated_successful_billing_response
  end

  def cancel(*)
    simulated_successful_billing_response
  end

  def void(*)
    simulated_successful_billing_response
  end

  def source_required?
    false
  end

  def credit(*)
    simulated_successful_billing_response
  end

  private

  def simulated_successful_billing_response
    ActiveMerchant::Billing::Response.new(true, "", {}, {})
  end
end
