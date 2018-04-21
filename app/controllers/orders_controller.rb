class OrdersController < ApplicationController
  # before_action :check_authorization, except: [:reset, :show]
  # before_action :apply_coupon_code, only: :update
  # rescue_from ActiveRecord::RecordNotFound, :with => :page_not_found
  # helper 'products', 'orders'
  # before_action :set_order

  respond_to :html

  # before_action :assign_order_with_lock, only: :update
  # before_action :verify_authentication, only: [:shipped_track]
  # skip_before_action :verify_authenticity_token, only: [:populate]

  layout 'product'

  def show
    @order = Order.includes(line_items: [product: [:images]]).find_by_number!(params[:id])
  end

  def update
    if @order.contents.update_cart(order_params)
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            @order.next if @order.cart?
            if @order.state == 'address'
              redirect_to checkout_address_path(state: 'address')
            elsif @order.state == 'payment'
              redirect_to checkout_payment_path(state: 'payment')
            else
              redirect_to checkout_state_path(@order.checkout_steps.first)
            end
          else
            redirect_to cart_checkout_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

  # Shows the current incomplete order from the session
  def edit
    @order = current_order || Order.incomplete.
        includes(line_items: [variant: [:images, :option_values, :product]]).
        find_or_initialize_by(guest_token: cookies.signed[:guest_token])
    associate_user
    return redirect_to root_path unless @order.line_items.length > 0
    # product = @order.line_items.first.product
    # # @recommend_products = product.recommended_products
    # # unless @recommend_products.length > 0
    # #   @recommend_products = product.get_recom_products
    # # end
    @title = "Your Shipping Bag – Brandcruz.com Secure Shopping"
    @keywords = "brandcruz, Brand Cruz, Brandcruz.com"
    @description = "Shop for shopping cart cover at Brandcruz.com. Free Shipping. Free Returns. All the time."
  end

  def reset
    current_order.empty!
    current_order.destroy
    redirect_to products_path
  end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
    @error = nil
    order = current_order(true)
    variant = Product.find(params[:variant_id])
    quantity = params[:quantity].to_i
    size = params[:size]
    options = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        line_item = order.contents.add(variant, quantity, options)
        line_item.size = size
        line_item.save
      rescue ActiveRecord::RecordInvalid => e
        @error = e.record.errors.full_messages.join(", ")
      end
    else
      @error = t(:please_enter_reasonable_quantity)
    end

    respond_to do |format|
      format.html do
        if @error
          flash[:error] = @error
          redirect_back_or_default(root_path)
        else
          respond_with(order) do |format|
            format.html { redirect_to cart_checkout_path }
          end
        end
      end
      format.js { render layout: false }
    end
  end

  def shipped_track
    @orders = Order.all #try_spree_current_user.orders.complete.order('completed_at desc')
    @order = Order.find_by_number(params[:order_id]) || Order.find_by_id(params[:order_id])
    @trackes = @order.shipment.trackings.order('created_at desc').group_by { |track| track.created_at.strftime('%A, %d %b') }
  end

  def empty
    if @order = current_order
      @order.empty!
    end

    redirect_to cart_checkout_path
  end

  def accurate_title
    if @order && @order.completed?
      t(:order_number, :number => @order.number)
    else
      t(:shopping_cart)
    end
  end

  def check_authorization
    order = Order.find_by_number(params[:id]) || current_order
    if order
      authorize! :edit, order, cookies[:guest_token]
    else
      authorize! :create, Order
    end
  end

  def apply_coupon
    @order = current_order
    @error = "Order not found"
    if @order.present? && params[:coupon_code].present?
      @order.coupon_code = params[:coupon_code]

      handler = PromotionHandler::Coupon.new(@order).apply

      if handler.error.present?
        @error = handler.error
      elsif handler.success
        @success = handler.success
      end
    else
      @error = "Order or coupon code not found"
    end

    respond_to do |format|
      format.js {}
    end
  end

  def remove_coupon
    @order = current_order
    @success = false
    if @order.present?
      order_promotions = @order.order_promotions.where(promotion_id: params[:id]).first
      adjustments = @order.adjustments
      if adjustments.length > 0
        adjustments.destroy_all
      end
      order_promotions.destroy
      # Adjustable::AdjustmentsUpdater.update(@order)
      @success = true
    end
  end

  private

  def set_order
    @order = current_order(true)
  end

  def apply_coupon_code
    assign_order_with_lock

    if params[:orders] && params[:orders][:coupon_code] && @order.present?

      @order.coupon_code = params[:orders][:coupon_code]

      handler = PromotionHandler::Coupon.new(@order).apply

      if handler.error.present?
        flash[:error] = handler.error
        respond_with(@order) { |format| format.html { redirect_to cart_checkout_path } } and return
      elsif handler.success
        flash[:success] = handler.success
      end
    end
  end

  def order_params
    if params[:orders]
      params[:orders].permit(*permitted_order_attributes)
    else
      {}
    end
  end

  def verify_authentication
    unless current_user
      redirect_to '/secure-user-signin-signup'
    end
  end

  def assign_order_with_lock
    @order = current_order(lock: true)
    unless @order
      flash[:error] = t(:order_not_found)
      redirect_to root_path and return
    end
  end
end