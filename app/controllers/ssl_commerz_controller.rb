class SslCommerzController < ApplicationController

  def ssl_express
    begin
      require 'net/http'
      require 'uri'

      uri = URI.parse("https://sandbox.sslcommerz.com/gwprocess/v3/api.php")
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(store_id: "liene5b0de4ddbc650", store_passwd: "liene5b0de4ddbc650@ssl", total_amount: 100.00, currency: "BDT",tran_id: "tran_id", success_url: "https://73345f3f.ngrok.io/ssl_commerz/confirm",fail_url: "https://73345f3f.ngrok.io/ssl_commerz/failed", cancel_url: "https://73345f3f.ngrok.io/ssl_commerz/cancel", emi_option: 0, cus_name: "Customer Name",cus_email: "cust@yahoo.com", cus_phone: "01921500119")
      req_options = {
          use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, req_options) do |http|
        http.request(request)
      end

     p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,"
     p response.code
     p response_body = JSON.parse(response.body)
     p response_body["GatewayPageURL"]
     p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,"
    redirect_to response_body["GatewayPageURL"]
    rescue => e
      puts "failed #{e}"
    end
  end

  def confirm

  end

  def cancel

  end

  def failed

  end
end
