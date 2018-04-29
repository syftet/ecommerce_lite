class Api::V1::CheckoutController < Api::ApiBase

  #include Core::ControllerHelpers::StrongParameters

  before_action :set_user, only: :update_order
  before_action :load_order, only: :update_order
  before_action :set_state_if_present
  before_action :ensure_order_not_completed
  before_action :ensure_checkout_allowed
  before_action :ensure_valid_state
  before_action :associate_user
  before_action :setup_for_current_state
  before_action :add_store_credit_payments, only: [:update_order]

  def update_order
    if !@error.present? && @order.present?
      p 'jasdasdahs'
      cur_order = @order
      if @order.update_from_params(params, nil, request.headers.env)
        @order.temporary_address = !params[:save_user_address]
        express_payment if params[:payer_id].present?
        if @order.next
          cur_order = nil if @order.completed? && !@order.payment_failed?
          # express_payment if params[:payer_id].present?
        else
          @error = @order.errors.full_messages.join("\n")
          ######@order.state
        end
      else
        message = []
        @order.errors.each do |key, msg|
          message.push("#{key.to_s.gsub('.', ' ').humanize} #{msg}")
        end
        @error = message.join("\n")
      end
    end

    render json: {
        status: !@error.present?,
        error: @error,
        state: @order.present? ? @order.state : '',
        has_order: cur_order.present?,
        has_failed: params[:failed_id].present?,
        failed_id: params[:failed_id]
    }
  end

  private

  def express_payment
    @order.payments.create!({
                                source: PaypalExpressCheckout.create({payer_id: params[:payer_id]}),
                                state: 'completed',
                                amount: @order.total,
                                payment_method: payment_method('PaymentMethod::PayPalExpress')
                            })
  end

  def ensure_valid_state
    if @order.present?
      if @order.state != correct_state && !skip_state_validation?
        flash.keep
        @order.update_column(:state, correct_state)
        if @order.state == 'payment'
          if params[:failed_id].present?
            @failed_id = params[:failed_id]
            @error = 'Payment failed for this order. Please check payment.'
          else
            @error = 'Need to check payment state.'
          end
        else
          @error = 'Invalid state'
        end
      end
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

  def set_state_if_present
    if @order.present? && params[:state]
      # if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
      #   if params[:failed_id].present?
      #     redirect_to checkout_state_path(@order.state, failed_id: params[:failed_id])
      #   else
      #     redirect_to checkout_state_path(@order.state)
      #   end
      # end
      @order.state = params[:state]
    end
  end

  def skip_state_validation?
    false
  end

  def ensure_order_not_completed
    @error = 'Order already complete.' if @order.present? && @order.completed? && !@order.payment_failed?
  end

  def ensure_checkout_allowed
    if @order.present?
      unless @order.checkout_allowed?
        @error = 'You can not able to checkout an empty cart'
      end
    end
  end

  def order_update_params
    params[:order] = {
        email: params[:email],
        use_shipping: params[:use_shipping]
    }

    if params[:state] == 'address'
      params[:order][:ship_address_attributes] = {
          firstname: params[:first_name],
          last_name: params[:last_name],
          address1: params[:address1],
          city: params[:city],
          zipcode: params[:zipcode],
          phone: params[:phone],
          state: params[:state],
          country: params[:country]
      }

      params[:order][:ship_address_attributes][:id] = params[:ship_address_id] if params[:ship_address_id].present?
    end

    params
  end

  def current_order_params
    { currency: current_currency, guest_token: @token, store_id: nil, user_id: params[:user_id] }
  end

  def current_currency
    'bdt'
  end

  def find_cart_by_token_or_user
    if params[:guest_token].present?
      @token = params[:guest_token]
      guest_token_order_params = current_order_params.except(:user_id)
      incomplete_orders = Order.incomplete.includes(line_items: [variant: [:images, :option_values, :product]])
      cart = incomplete_orders.find_by(guest_token_order_params)
    elsif params[:user_id].present?
      user = User.find_by_id(params[:user_id])
      cart = user.last_incomplete_spree_order
    end

    cart
  end

  def load_order
    if params[:guest_token].present?
      @token = params[:guest_token]
      guest_token_order_params = current_order_params.except(:user_id)
      incomplete_orders = Order.incomplete.includes(line_items: [variant: [:images, :option_values, :product]])
      @order = incomplete_orders.find_by(guest_token_order_params)
    elsif params[:user_id].present?
      user = User.find_by_id(params[:user_id])
      @order = user.last_incomplete_spree_order
    else
      @error = 'Order not found'
    end
  end

  def associate_user
    if @current_user && @order.present?
      @order.associate_user!(@current_user) if @order.user.blank? || @order.email.blank?
    end
  end

  def check_authorization
    if @current_user.present? && @order.present?
      @order.user_id == @current_user.id
    end
  end

  def setup_for_current_state
    if @order.present?
      method_name = :"before_#{@order.state}"
      send(method_name) if respond_to?(method_name, true)
    end
  end

  def before_address
    # if the user has a default address, a callback takes care of setting
    # that; but if he doesn't, we need to build an empty one here
    @order.bill_address ||= Address.build_default
    @order.ship_address ||= Address.build_default if @order.checkout_steps.include?('delivery')
  end

  def before_delivery
    return if params[:order].present? && !@order.present?

    packages = @order.shipments.map(&:to_package)
    @differentiator = Stock::Differentiator.new(@order, packages)
  end

  def before_payment
    if @order.checkout_steps.include? "delivery"
      packages = @order.shipments.map(&:to_package)
      @differentiator = Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        #@order.contents.remove(variant, quantity)
      end
    end

    if @current_user && @current_user.respond_to?(:payment_sources)
      @payment_sources = @current_user.payment_sources
    end
  end

  def add_store_credit_payments
    if params.has_key?(:apply_store_credit) && @order.present?
      @order.add_store_credit_payments

      # Remove other payment method parameters.
      params[:order].delete(:payments_attributes)
      params.delete(:payment_source)

      # Return to the Payments page if additional payment is needed.
      if @order.payments.valid.sum(:amount) < @order.total
        @error = 'Need additional payment to complete the order'
        #redirect_to checkout_state_path(@order.state) and return
      end
    end
  end

  def set_user
    p 'set user'
    @user = User.find_by_tokens(params[:token])
    if @user.present?
      bypass_sign_in(@user)
      warden.set_user @user
      @current_user = @user
    end
  end
  def payment_method(type)
    PaymentMethod.find_by_type(type)
  end

end