# This is somewhat contrary to standard REST convention since there is not
# actually a Checkout object. There's enough distinct logic specific to
# checkout which has nothing to do with updating an order that this approach
# is waranted.
class CheckoutController < ApplicationController
  before_action :load_order_with_lock
  # before_action :ensure_valid_state_lock_version, only: [:update]
  # before_action :set_state_if_present
  #
  before_action :ensure_order_not_completed
  before_action :ensure_checkout_allowed
  # # before_action :ensure_sufficient_stock_lines
  # before_action :ensure_valid_state
  #
  # before_action :associate_user
  # before_action :check_authorization
  #
  before_action :setup_for_current_state
  # before_action :add_store_credit_payments, only: [:update]
  # before_action :validate_state, only: [:edit]
  #
  # helper 'orders'
  layout 'product'
  # rescue_from Core::GatewayError, with: :rescue_from_spree_gateway_error

  # Updates the order and advances to the next state (when possible.)
  def update
    if @order.update_with_params(params, permitted_checkout_attributes)
      if @order.next
        redirect_to checkout_state_path(@order.state)
      else

      end
    else
      render @order.state
    end
  end

  def edit
    if @order.state == 'address'
      @title = "Secure checkout SSL | Shipping Address - BrandCruz"
    elsif @order.state == 'payment'
      @title = "SSL Secured Payment Processing - BrandCruz"
    elsif @order.state == 'complete' && params[:failed_id].present?
      @title = "SSL Secured Payment Processing - BrandCruz"
      @order.state = 'payment'
    end
    @order.state = params[:state] if params[:state]
  end

  private

  def permitted_checkout_attributes
    params[:order].permit!
  end

  def validate_state
    if @order.state == 'address'
      before_address
    end
  end

  def unknown_state?
    (params[:state] && !@order.has_checkout_step?(params[:state])) ||
        (!params[:state] && !@order.has_checkout_step?(@order.state))
  end

  def insufficient_payment?
    params[:state] == "confirm" &&
        @order.payment_required? &&
        @order.payments.valid.sum(:amount) != @order.total
  end

  def correct_state
    if unknown_state?
      @order.checkout_steps.first
    elsif insufficient_payment?
      'payment'
    else
      @order.state
    end
  end

  def ensure_valid_state
    p @order.state
    if @order.state != correct_state && !skip_state_validation?
      flash.keep
      @order.update_column(:state, correct_state)
      if @order.state == 'payment'
        if params[:failed_id].present?
          redirect_to checkout_payment_path(state: 'payment', failed_id: params[:failed_id])
        else
          redirect_to checkout_payment_path(state: 'payment')
        end
      else
        redirect_to checkout_state_path(@order.state)
      end
    end
  end

  # Should be overriden if you have areas of your checkout that don't match
  # up to a step within checkout_steps, such as a registration step
  def skip_state_validation?
    false
  end

  def load_order_with_lock
    @order = current_order
  end

  def ensure_valid_state_lock_version
    if params[:order] && params[:order][:state_lock_version]
      @order.with_lock do
        unless @order.state_lock_version == params[:order].delete(:state_lock_version).to_i
          #flash[:error] = t(:order_already_updated)
          #redirect_to(checkout_state_path(@order.state)) && return TODO: Need to activate
        end
        @order.increment!(:state_lock_version)
      end
    end
  end

  def set_state_if_present
    if params[:state]
      if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
        if params[:failed_id].present?
          redirect_to checkout_state_path(@order.state, failed_id: params[:failed_id])
        else
          redirect_to checkout_state_path(@order.state)
        end
      end
      @order.state = params[:state]
    end
  end

  def ensure_checkout_allowed
    unless @order.line_items.count > 0
      flash[:error] = "Your shopping cart is empty"
      redirect_to products_path
    end
  end

  def ensure_order_not_completed
    redirect_to products_path if @order.completed?
  end

  def ensure_sufficient_stock_lines
    if @order.insufficient_stock_lines.present?
      flash[:error] = t(:inventory_error_flash_for_insufficient_quantity)
      redirect_to cart_checkout_path
    end
  end

  # Provides a route to redirect after order completion
  def completion_route(custom_params = nil)
    order_path(@order, custom_params)
  end

  def setup_for_current_state
    method_name = :"before_#{@order.state}"
    send(method_name) if respond_to?(method_name, true)
  end

  def before_address
    @order.ship_address ||= Address.build_default
  end

  def before_delivery
    unless @order.ship_address.present?
      redirect_to checkout_state_path('address')
    end
  end

  def before_payment
    before_address
    unless @order.shipment.present?
      packages = @order.shipments.map(&:to_package)
      @differentiator = Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        #@order.contents.remove(variant, quantity)
      end
    end

    if current_user && current_user.respond_to?(:payment_sources)
      @payment_sources = current_user.payment_sources
    end
  end

  def add_store_credit_payments
    if params.has_key?(:apply_store_credit)
      @order.add_store_credit_payments

      # Remove other payment method parameters.
      params[:order].delete(:payments_attributes)
      params.delete(:payment_source)

      # Return to the Payments page if additional payment is needed.
      if @order.payments.valid.sum(:amount) < @order.total
        redirect_to checkout_state_path(@order.state) and return
      end
    end
  end

  def check_authorization
    if current_user.present?
      @order.user_id == current_user.id
    else
      authorize!(:edit, current_order, cookies[:guest_token])
    end
  end

  def strip_zip(address_params)
    return unless address_params
    address_params[:zipcode] = address_params[:zipcode].strip if address_params[:zipcode]
  end
end
