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

class PaymentMethod::SslCommerz < PaymentMethod
  PREFERENCES = [
      {field: :store_id, type: :string, default: ''},
      {field: :store_passwd, type: :string, default: ''},
  ]
  include Preferable

  def auto_capture?
    true
  end

  def process
    {state: 'Complete', response_code: 200, response_message: 'Payment success'}
  end

 end
