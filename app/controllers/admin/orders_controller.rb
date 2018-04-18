module Admin
  class OrdersController < BaseController
    before_action :initialize_order_events
    before_action :load_order, only: [:edit, :update, :cancel, :resume, :approve, :resend, :open_adjustments, :close_adjustments, :cart, :track, :update_state]

    respond_to? :html

    def index
      params[:q] ||= {}
      # params[:q][:completed_at_not_null] ||= '1' if Syftet.config.show_only_complete_orders_by_default
      # @show_only_completed = params[:q][:completed_at_not_null] == '1'
      # created_at_gt = params[:q][:created_at_gt]
      # created_at_lt = params[:q][:created_at_lt]
      #
      # params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"
      #
      # if params[:q][:created_at_gt].present?
      #   params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
      # end
      #
      # if params[:q][:created_at_lt].present?
      #   params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
      # end
      #
      # if @show_only_completed
      #   params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
      #   params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
      # end

      # @search = Order.preload(:user).accessible_by(current_ability, :index).ransack(params[:q])
      # @orders = @search.result(distinct: true).
      #     page(params[:page]).
      #     per(params[:per_page] || Syftet.config.orders_per_page)
      # params[:q][:created_at_gt] = created_at_gt
      # params[:q][:created_at_lt] = created_at_lt
      @search = Order.new
      @orders = Order.all
    end

    def new
      @order = Order.create(order_params)
      redirect_to cart_admin_order_url(@order)
    end

    def edit
      # can_not_transition_without_customer_info

      unless @order.completed?
#        @order.refresh_shipment_rates(ShippingMethod::DISPLAY_ON_FRONT_AND_BACK_END)
      end
    end

    def cart
      # unless @order.completed?
      #   @order.refresh_shipment_rates
      # end
      # if @order.shipments.shipped.count > 0
      #   redirect_to edit_admin_order_url(@order)
      # end
    end

    def update
      if @order.update_attributes(params[:orders]) && @order.line_items.present?
        @order.update_with_updater!
        unless @order.completed?
          # Jump to next step if order is not completed.
          redirect_to admin_order_customer_path(@order) and return
        end
      else
        @order.errors.add(:line_items, t('errors.messages.blank')) if @order.line_items.empty?
      end

      render action: :edit
    end

    def cancel
      @order.canceled_by(current_user)
      flash[:success] = t(:order_canceled)
      redirect_back fallback_location: admin_order_path(@order)
    end

    def resume
      @order.resume!
      flash[:success] = t(:order_resumed)
      redirect_to :back
    end

    def approve
      if @order.update_attributes({shipment_date: params[:order][:shipment_date], shipment_progress: params[:order][:shipment_progress], state: 'approved'})
        @order.approved_by(current_user)
        @order.credit_rewards_point
      end
      flash[:success] = t(:order_approved)
      redirect_to edit_admin_order_path(params[:id])
    end

    def resend
      OrderMailer.confirm_email(@order.id, true).deliver_later
      flash[:success] = t(:order_email_resent)

      redirect_back fallback_location: admin_order_path(@order)
    end

    def open_adjustments
      adjustments = @order.all_adjustments.closed
      adjustments.update_all(state: 'open')
      flash[:success] = t(:all_adjustments_opened)

      respond_with(@order) { |format| format.html { redirect_to :back } }
    end

    def close_adjustments
      adjustments = @order.all_adjustments.open
      adjustments.update_all(state: 'closed')
      flash[:success] = t(:all_adjustments_closed)

      respond_with(@order) { |format| format.html { redirect_to :back } }
    end

    def shipment_tracking
      @shipment = Shipment.find_by_id(params[:shipment_id])
      @shipment.update_attribute(:tracking, params[:tracking])
    end

    def customer

    end

    def track
      @trackes = @order.shipment.trackings.order('created_at').group_by { |track| track.created_at.strftime('%A, %d %b') }
    end

    def update_state
      order_params = params[:order]
      status = order_params[:shipment_state]
      update_params = {}
      if 'payment_failed' == status
        update_params = {
            state: 'payment',
            payment_state: 'failed',
            shipment_state: nil,
            approver_id: '',
            shipped_at: nil,
            confirmation_delivered: nil
        }
      else
        update_params = {
            shipment_state: status == 'processing' ? nil : status,
            shipment_date: format_date(order_params[:shipment_date]),
            shipment_progress: order_params[:shipment_progress].present? ? order_params[:shipment_progress] : 0,
            # shipped_at: (!@order.shipped_at.present? && status == 'shipped') ? DateTime.now : @order.shipped_at,
            payment_state: status == 'shipped' ? 'paid' : @order.payment_state
        }
      end
      if @order.update_attributes(update_params)
        comments = params[:comments].present? ? params[:comments] : "Order status updated to #{Spree::Order::ORDER_ALL_SHIPMENT_STATE[status.to_sym]}"
        @order.shipment.trackings.create(comment: comments, user_id: current_user.id)
        flash[:success] = 'Order status has been updated'
        if @order.shipment_state == 'shipped'
          #Spree::OrderMailer.update_order(@order).deliver_now
        end
        redirect_back fallback_location: admin_order_path(@order)
      else
        render :edit
      end
    end

    private
    def order_params
      params[:created_by_id] = current_user.try(:id)
      params.permit(:created_by_id, :user_id)
    end

    def load_order
      @order = Order.friendly.find(params[:id])
      authorize! action, @order
    end

    # Used for extensions which need to provide their own custom event links on the order details view.
    def initialize_order_events
      @order_events = %w{cancel resume}
    end

    def model_class
      Order
    end

    def format_date(date)
      if date.present?
        dates = date.split('/')
        "#{dates.last}-#{dates.first}-#{dates.second}"
      else
        nil
      end
    end

  end
end