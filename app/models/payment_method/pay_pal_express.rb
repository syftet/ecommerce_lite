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

# require 'paypal-sdk-merchant'
class PaymentMethod::PayPalExpress < PaymentMethod

  PREFERENCES = [
      {field: :login, type: :string, default: ''},
      {field: :password, type: :string, default: ''},
      {field: :signature, type: :string, default: ''},
      {field: :server, type: :string, default: 'sandbox'},
      {field: :solution, type: :string, default: 'Mark'},
      {field: :landing_page, type: :string, default: 'Billing'},
      {field: :logourl, type: :string, default: ''},
      {field: :conversion_rate, type: :float, default: 83.00}
  ]
  include Preferable

  def supports?(source)
    true
  end

  def provider_class
    ::PayPal::SDK::Merchant::API
  end

  def provider
    ::PayPal::SDK.configure(
        :mode => preferred_server.present? ? preferred_server : "sandbox",
        :username => self.preferred_login,
        :password => self.preferred_password,
        :signature => self.preferred_signature)
    provider_class.new
  end

  def auto_capture?
    true
  end

  def method_type
    'paypal'
  end

  # def preferred_solution
  #   self.solution
  # end

  def purchase(amount, express_checkout, gateway_options={})
    pp_details_request = provider.build_get_express_checkout_details({
                                                                         :Token => express_checkout.token
                                                                     })
    pp_details_response = provider.get_express_checkout_details(pp_details_request)

    pp_request = provider.build_do_express_checkout_payment({
                                                                :DoExpressCheckoutPaymentRequestDetails => {
                                                                    :PaymentAction => "Sale",
                                                                    :Token => express_checkout.token,
                                                                    :PayerID => express_checkout.payer_id,
                                                                    :PaymentDetails => pp_details_response.get_express_checkout_details_response_details.PaymentDetails
                                                                }
                                                            })

    pp_response = provider.do_express_checkout_payment(pp_request)
    if pp_response.success?
      # We need to store the transaction id for the future.
      # This is mainly so we can use it later on to refund the payment if the user wishes.
      transaction_id = pp_response.do_express_checkout_payment_response_details.payment_info.first.transaction_id
      express_checkout.update_column(:transaction_id, transaction_id)
      # This is rather hackish, required for payment/processing handle_response code.
      Class.new do
        def success?;
          true;
        end

        def authorization;
          nil;
        end
      end.new
    else
      class << pp_response
        def to_s
          errors.map(&:long_message).join(" ")
        end
      end
      pp_response
    end
  end

  def refund(payment, amount)
    refund_type = payment.amount == amount.to_f ? "Full" : "Partial"
    refund_transaction = provider.build_refund_transaction({
                                                               :TransactionID => payment.source.transaction_id,
                                                               :RefundType => refund_type,
                                                               :Amount => {
                                                                   :currencyID => payment.currency,
                                                                   :value => amount},
                                                               :RefundSource => "any"})
    refund_transaction_response = provider.refund_transaction(refund_transaction)
    if refund_transaction_response.success?
      payment.source.update_attributes({
                                           :refunded_at => Time.now,
                                           :refund_transaction_id => refund_transaction_response.RefundTransactionID,
                                           :state => "refunded",
                                           :refund_type => refund_type
                                       })

      payment.class.create!(
          :order => payment.order,
          :source => payment,
          :payment_method => payment.payment_method,
          :amount => amount.to_f.abs * -1,
          :response_code => refund_transaction_response.RefundTransactionID,
          :state => 'completed'
      )
    end
    refund_transaction_response
  end
end
