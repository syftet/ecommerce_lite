class Api::V1::OrdersController < Api::ApiBase
   include Core::TokenGenerator

  before_action :load_user, only: [:index]

  def index
    response = []

    @user.orders.each do |order|
      item_count = order.line_items.count
      if item_count > 0
        product = order.line_items.first.product
        image = helpers.product_preview_image(product),
        name = product.name
      else
        image = ''
        name = ''
      end
      response << {
          id: order.id,
          number: order.number,
          items: item_count,
          image: image,
          name: name,
          order_state: order.state,
          payment_state: order.payment_state,
          shipment_state: order.shipment_state,
          completed_at: order.completed_at,
          shipment_date: order.shipment_date,
          shipped_at: order.shipped_at
      }
    end

    render json: {
        success: true,
        orders: response
    }
  end

  def show
    @order = Order.includes(:ship_address, line_items: [product: [:images] ]).find_by_number!(params[:id])
    shipment_address = @order.ship_address
    # bill_address = @order.bill_address
    line_items = []
    @order.line_items.each do |line_item|
      product = line_item.product
      # variant = line_item.variant
      line_items << {
          id: line_item.id,
          quantity: line_item.quantity,
          product_id: product.id,
          variant_id: product.id,
          name: product.name,
          price: product.price,
          preview_image: helpers.product_preview_image(product),
          color_image: product.color,
          size: product.size,
          total: line_item.total
      }
    end
    render json: {
        just_completed: false,
        # bill_address: address_hash(bill_address),
        ship_address: address_hash(shipment_address),
        line_items: line_items,
        amount: @order.total,
        # is_promotional: @order.promotions.present?,
        adjustment_total: @order.adjustment_total,
        shipment: @order.shipment.present? ? shipping_method(@order.shipment) : '',
        total: @order.total,
        id: @order.id,
        number: @order.number,
        email: @order.email,
        collection_point: @order.collection_point,
        special_instructions: @order.special_instructions,
        state: @order.state
    }
  end

  def detail
    cart = find_cart_by_token_or_user


    result = {}

    if cart.present?
      result = {
          id: cart.id,
          number: cart.number,
          state: cart.state,
          guest_token: cart.guest_token,
          total: cart.total,
          total_item: cart.item_count,
          line_items: []
      }

      cart.line_items.each do |line_item|
        product = line_item.product
        result[:line_items] << {
            id: line_item.id,
            quantity: line_item.quantity,
            product_id: product.id,
            name: product.name,
            price: product.price,
            preview_image:  helpers.product_preview_image(product),
            color_image: product.color,
            total: line_item.total
        }
      end
    end

    render json: {
        status: cart.present?,
        order: result
    }
  end

  def update_order
    order = Order.find_by_id(params[:order_id])
    error = ''
    total = line_item_total = 0.0
    item_count = line_item_count = 0
    if order.present?
      line_item = order.line_items.find_by_id(params[:line_item_id])
      if line_item && params[:quantity].present? && line_item.quantity.present?
        add_or_remove_quantity = params[:quantity].to_i - line_item.quantity.to_i
        existing_quantity = line_item.quantity + add_or_remove_quantity
        if add_or_remove_quantity > 0
          line_item = order.contents.add(line_item.product, add_or_remove_quantity, {})
        elsif add_or_remove_quantity < 0 && existing_quantity > 0
          line_item = order.contents.remove(line_item.product, add_or_remove_quantity.abs, {})
        else
          error = "Line item quantity can't be 0"
        end
        error = line_item.errors.first unless line_item.save
        line_item_total = line_item.total
        line_item_count = line_item.quantity
      else
        error = 'Line item not found'
      end
      total = order.total
      item_count = order.item_count
    else
      error = 'Order not found'
    end

    render json: {
        status: !error.present?,
        error: error,
        total: total,
        line_item_total: line_item_total,
        item_count: item_count,
        line_item_count: line_item_count
    }
  end

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

    render json: {
        status: !@error.present?,
        error: @error,
        token: order.guest_token,
        total_item: order.present? ? order.item_count : 0
    }
  end

  def current_cart
    cart = find_cart_by_token_or_user

    if cart.present?
      token = cart.guest_token
      total_item = cart.item_count
    else
      token = ''
      total_item = 0
    end

    render json: {
        status: cart.present?,
        token: token,
        total_item: total_item
    }
  end

  def current_state
    cart = find_cart_by_token_or_user

    if cart.present? && cart.state == 'cart'
      p 'updating to address'
      cart.update_attributes(state: 'address')
    end

    render json: {
        status: cart.present?,
        state: cart.present? ? cart.state : ''
    }
  end

  def get_ship_address
    order = find_cart_by_token_or_user

    address = {
        firstname: '',
        lastname: '',
        address: '',
        country: '',
        city: '',
        state: '',
        zipcode: '',
        phone: ''
    }
    if order.state == 'cart' || order.state == 'address'
      p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,,"
      p order.inspect
      p order.ship_address
      p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<,,"
      ship_address = order.ship_address
      if ship_address.present?
        address[:firstname] = ship_address[:firstname]
        address[:lastname] = ship_address[:lastname]
        address[:address] = ship_address[:address]
        address[:country] = ship_address[:country]
        address[:city] = ship_address[:city]
        address[:state] = ship_address[:state]
        address[:zipcode] = ship_address[:zipcode]
        address[:phone] = ship_address[:phone]
      end
    end

    render json: {
        state: order.state,
        ship_address: address,
        email: order.email,
        order_summary: {
            amount: order.item_total,
            adjustment_total: order.adjustment_total,
            shipment: order.shipment.present? ? shipping_method(order.shipment) : '',
            total: order.total
        }
    }
  end

  def update_address
    error = ''
    order =  find_cart_by_token_or_user
    if order.present? && !order.completed?
      if order.ship_address.present?
        if order.ship_address.update_attributes(ship_address_params)
        else
          error = 'Shipping address update failed. Try again later.'
        end
      else
        p "heres"
        address = Address.new(ship_address_params)
        if address.save
          bill_address = Address.new(ship_address_params)
          bill_address.save
          order.update_attributes(bill_address_id: bill_address.id, ship_address_id: address.id)
        else
          p address.errors.inspect
          error = 'Shipping address creation failed. Please try again later.'
        end
      end
    else
      error = 'Order not found or already complete'
    end

    order.update_attributes(email: params[:email], state: 'delivery') unless error.present?

    render json: {
        status: !error.present?,
        error: error
    }
  end

  def get_shipments
    error = ''
    order =  find_cart_by_token_or_user

    shipments = []
    differentiators = []
    special_instructions = ''
    collection_point = ''
    ship_address = {
        name: '',
        address: '',
        city: '',
        state: '',
        zipcode: '',
        country: '',
        phone: ''
    }

    if order.present?
      # p order.shipments
      # p order.shipments.first.stock_location.name
      # p order.shipments.first.manifest
      # order.shipments.first.manifest.each do |item|
      #   p item.variant.product
      #   p item.variant.images
      #   p item.variant.images.order(:id).first.attachment.url(:small)
      #   p item.quantity
      #   p item.variant.price
      # end
      #
      # p order.shipments.first.shipping_rates

      special_instructions = order.special_instructions
      shipment = order.shipment
      # order.shipment.each do |shipment|
        shipment_data = {
            id: shipment.id,
            stock_location: shipment.stock_location.name,
            stock_location_id: shipment.stock_location_id,
            manifests: [],
            shipping_rates: []
        }

        # shipment.manifest.each do |item|
        #   product = item.variant.product
        #   shipment_data[:manifests] << {
        #       image: product.present? ? product.images.order(:id).first.attachment.url(:small) : '',
        #       name: item.variant.name,
        #       quantity: item.quantity,
        #       price: item.variant.price,
        #       line_item_id: item.line_item.id,
        #       variant_id: item.variant.id
        #   }
        # end


          shipment_data[:shipping_rates] << {
              id: shipping_method.id,
              name: shipping_method.name,
              cost: shipping_method.rate
          }

        shipments << shipment_data
    end

    render json: {
        status: !error.present?,
        error: error,
        shipments: shipments,
    }
  end

  def get_payment_info
    @order =  Order.find_by_id(37) #find_cart_by_token_or_user
    user = User.find_by_id(params[:user_id])
    shipment_address = @order.ship_address
    # bill_address = @order.bill_address

    render json: {
        ship_address: address_hash(shipment_address),
        amount: @order.item_total,
        # is_promotional: @order.promotions.present?,
        adjustment_total: @order.adjustment_total,
        shipment: @order.shipment.present? ? shipping_method(@order.shipment) : '',
        total: @order.total,
        id: @order.id,
        number: @order.number,
        email: @order.email,
        collection_point: @order.collection_point,
        special_instructions: @order.special_instructions,
        state: @order.state,
        paypal_amount: @order.total * 100,
        available_rewards: user.present? ? user.available_rewards : 0,
        payment_methods: {
            credit_point: payment_method('PaymentMethod::CreditPoint'),
            paypal_express: payment_method('PaymentMethod::PayPalExpress'),
            cash: payment_method('PaymentMethod::Cash')
        }
    }
  end


  private

  def address_hash(address)
    {
        name: address.firstname,
        address: address.address,
        city: address.city,
        state: address.state,
        zipcode: address.zipcode,
        country: address.country,
        phone: address.phone
    }
  end

  def ship_address_params
    { firstname: params[:ship_address][:firstname], last_name: params[:ship_address][:lastname], address: params[:ship_address][:address], city: params[:ship_address][:city], zipcode: params[:ship_address][:zipcode], phone: params[:ship_address][:phone], state: params[:ship_address][:state], country: params[:ship_address][:country] }
  end

  def last_incomplete_order
    @last_incomplete_order ||= current_user.last_incomplete_spree_order
  end

  # def current_order(options = {})
  #   options[:create_order_if_necessary] ||= false
  #
  #   return @current_order if @current_order
  #
  #   @current_order = find_order_by_token_or_user(options, true)
  #
  #   if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
  #     @current_order = Order.new(current_order_params)
  #     @current_order.user ||= current_user
  #     # See issue #3346 for reasons why this line is here
  #     @current_order.created_by_id ||=  current_user.id
  #     @current_order.state ||= 'cart'
  #     @current_order.save!
  #   end
  #
  #   if @current_order
  #     # @current_order.last_ip_address = ip_address
  #     return @current_order
  #   end
  # end

  def current_order_params
    { currency: current_currency, guest_token: @token, store_id: nil, user_id: params[:user_id] }
  end

  def current_currency
    'bdt'
  end

  def find_cart_by_token_or_user
    if params[:guest_token].present?
      @token = params[:guest_token]
      incomplete_orders = Order.incomplete.includes(:ship_address, line_items: [product: [:images] ])
      cart = incomplete_orders.where(guest_token: @token).last
    elsif params[:user_id].present?
      user = User.find_by_id(params[:user_id])
      cart = user.last_incomplete_spree_order
    end

    cart
  end

  def find_order_by_token_or_user(options = {}, with_adjustments = false)
    options[:lock] ||= false

    # Find any incomplete orders for the guest_token
    incomplete_orders = Order.incomplete.includes(line_items: [variant: [:images, :option_values, :product]])
    guest_token_order_params = current_order_params.except(:user_id)
    order = if with_adjustments
              incomplete_orders.lock(options[:lock]).find_by(guest_token_order_params)
            else
              incomplete_orders.lock(options[:lock]).find_by(guest_token_order_params)
            end

    # Find any incomplete orders for the current user
    order = last_incomplete_order if order.nil? && current_user

    order
  end

  def ip_address
    request.remote_ip
  end

  def shipping_method(shipment)
    shipping_rate = shipment.shipping_method
    return '' unless shipping_rate.present?
    shipping_rate.name + "(৳#{shipping_rate.rate})"
  end

  def payment_method(type)
    payment_method = PaymentMethod.find_by_type(type)
    payment_method.present? ? payment_method.id : 0
  end
end
