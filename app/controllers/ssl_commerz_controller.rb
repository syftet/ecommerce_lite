class SslCommerzController < ApplicationController
  skip_before_action :verify_authenticity_token

  def ssl_express
    begin

      require 'net/http'
      require 'uri'
      uri = URI.parse("https://sandbox.sslcommerz.com/gwprocess/v3/api.php")
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(store_id: "liene5b0de4ddbc650", store_passwd: "liene5b0de4ddbc650@ssl", total_amount: current_order.net_total, currency: "BDT",tran_id: current_order.number, success_url: confirm_ssl_url,fail_url: failed_ssl_url, cancel_url: cancel_ssl_url, emi_option: 0, cus_name: current_order.ship_address.full_name,cus_email: current_user.present? ? current_user.email : current_order.email, cus_phone: current_order.ship_address.phone)
      req_options = {
          use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, req_options) do |http|
        http.request(request)
      end

     response_body = JSON.parse(response.body)

    redirect_to response_body["GatewayPageURL"]
    rescue => e
      puts "failed #{e}"
    end
  end

  def confirm
    order = current_order || raise(ActiveRecord::RecordNotFound)
    payment_method = PaymentMethod.find_by_type('PaymentMethod::SslCommerz')
    payment = order.payments.create!({
                                         state: 'completed',
                                         amount: order.total,
                                         payment_method: payment_method
                                     })

    unless payment.errors.any?
      order.completed_at = Time.now
      order.state = 'completed'
      order.shipment_state = Order::ORDER_SHIPMENT_STATE[:pending]
      order.payment_state = payment.state == 'completed' ? 'completed' : 'balance_due'
      if order.save
        order.remove_stock_from_inverntory
        order.deliver_order_confirmation_email unless order.confirmation_delivered?
      end
    end


    if order.completed?
      flash.notice = I18n.t(:order_processed_successfully)
      flash[:order_completed] = true
      session[:order_id] = nil
      redirect_to  order_path(order)
    else
      redirect_to checkout_state_path(order.state)
    end
  end

  def cancel
    flash[:notice] = I18n.t('flash.cancel', scope: 'paypal')
    order = current_order || raise(ActiveRecord::RecordNotFound)
    redirect_to checkout_state_path(order.state)
  end

  def failed
    flash[:notice] = I18n.t('payment_states.failed')
    order = current_order || raise(ActiveRecord::RecordNotFound)
    redirect_to checkout_state_path(order.state)
  end
end
