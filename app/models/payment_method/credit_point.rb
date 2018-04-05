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

  def capture(*)
    response = simulated_successful_billing_response
    if response.success?
      update_rewards_points(-1 * amount.to_f, 'Purchased', options)
    end
  end

  def purchase(amount, source, options = {})
    response = simulated_successful_billing_response
    if response.success?
      update_rewards_points(-1 * amount.to_f, 'Purchased', options)
    end
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
    p order
    p order[:order_id]
    p order[:order_id].slice(0..(order[:order_id].rindex('-')))

    order_id = 0
    user_id = 0

    reward_order = Order.find_by_number(order[:order_id].slice(0..(order[:order_id].rindex('-') - 1)))

    p reward_order.inspect
    if reward_order.present?
      order_id = reward_order.id
      user_id = reward_order.user_id
    end

    RewardsPoint.create(order_id: order_id, points: amount, reason: reason, user_id: user_id)
  end

end
