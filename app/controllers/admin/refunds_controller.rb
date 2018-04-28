module Admin
  class RefundsController < BaseController
    before_action :load_order


    # rescue_from Core::GatewayError, with: :spree_core_gateway_error, only: :create TODO: Need to active

    def new
      @payment = Payment.friendly.find(params[:payment_id])
      @refund = @payment.refunds.new
      @order = Order.friendly.find(params[:order_id])
    end

    def edit
      @payment = Payment.friendly.find(params[:payment_id])
      @refund = @payment.refunds.find_by_id(params[:id])
      @order = Order.friendly.find(params[:order_id])
    end

    def create
      @payment = Payment.friendly.find(params[:payment_id])
      @order = Order.friendly.find(params[:order_id])
      @refund = @payment.refunds.new(refund_params)
      respond_to do |format|
        format.html do
          if @refund.save
            flash[:success] = "Order Item Successfully returned"
            redirect_to edit_admin_payment_method_path(@payment)
          else
            render :new
          end
        end
      end
    end

    private

    def location_after_save
      admin_order_payments_path(@payment.order)
    end

    def load_order
      # the spree/admin/shared/order_tabs partial expects the @order instance variable to be set
      @order = @payment.order if @payment
    end

    def refund_reasons
      @refund_reasons ||= RefundReason.active.all
    end

    def build_resource
      super.tap do |refund|
        refund.amount = refund.payment.credit_allowed
      end
    end

    def spree_core_gateway_error(error)
      flash[:error] = error.message
      render :new
    end

    def refund_params
      params.require(:refund).permit!
    end
  end
end