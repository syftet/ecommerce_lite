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
