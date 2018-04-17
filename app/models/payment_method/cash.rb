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

class PaymentMethod::Cash < PaymentMethod
  PREFERENCES = [{field: :amount, type: :string, default: 3}]
  include Preferable

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

  def capture(payment)
    payment.state = 'captured'
    if payment.save
      payment.order.update_attribute(:payment_state, 'paid')
    end
  end

  def cancel(*)
    simulated_successful_billing_response
  end

  def void(payment)
    payment.state = 'void'
    if payment.save
      payment.order.update_attribute(:payment_state, 'void')
    end
  end

  def source_required?
    false
  end

  def process
    {state: 'pending', response_code: 200, response_message: 'Payment success'}
  end

  def credit(*)
    simulated_successful_billing_response
  end
end
