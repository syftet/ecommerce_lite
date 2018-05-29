# == Schema Information
#
# Table name: paypal_express_checkouts
#
#  id          :integer          not null, primary key
#  token       :string(255)
#  payer_id    :string(255)
#  order_id    :integer
#  state       :string(255)      default("completed")
#  refund_id   :integer
#  refunded_at :datetime
#  refund_type :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PaypalExpressCheckout < ApplicationRecord
end
