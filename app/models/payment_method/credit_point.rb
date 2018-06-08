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

class PaymentMethod::CreditPoint < PaymentMethod
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

  def process
    {state: 'pending', response_code: 200, response_message: 'Payment success'}
  end

  def capture(payment)
    payment.state = 'captured'
    if payment.save
      payment.order.update_attribute(:payment_state, 'paid')
    end
  end

  def purchase(amount, source, options = {})
    response = simulated_successful_billing_response
    response
  end

  def cancel(amount, source, order, code)
    response = simulated_successful_billing_response
    if response.success?
      update_rewards_points(amount.to_f, 'Purchased Canceled', order)
    end
    response
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
    ActiveMerchant::Billing::Response.new(true, '', {}, {authorization: true})
  end

  def update_rewards_points(amount, reason, order)
    p '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    if order.present?
      order_id = order.id
      user_id = order.user_id
      RewardsPoint.create(order_id: order_id, points: amount, reason: reason, user_id: user_id)
    end
  end

end
