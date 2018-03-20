module Admin
  module Orders
    class CustomersController < BaseController
      respond_to? :html

      def show
        @order = Order.find_by_number(params[:order_id])
      end
    end
  end
end