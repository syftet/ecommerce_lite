class Api::ApiBase < ActionController::Base
  # include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers
  before_action :load_order

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

  def load_user
    @user = User.find_by_tokens(params[:token])
    if @user.present?
      bypass_sign_in(@user)
      warden.set_user @user
      @current_user = @user
    else
      render json: {success: false, error: 'Invalid user'}
    end
  end

  def current_order(create_order = false)
    p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    p params
    p @order
    p "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    if create_order && @order.blank?
      order = Order.new
      order.guest_token = get_token
      order.user_id = current_user.id if current_user.present?
      order.state = 'address'
      order.store = StockLocation.active_stock_location
      order.save!
      @order = order
    end
    unless @order.present? && @order.completed?
      @order
    end
  end

  def get_token
    token = params[:guest_token]
    unless token.present?
      token = SecureRandom.urlsafe_base64(nil, false)
      cookies[:guest_token] = {
          :value => token,
          :expires => 1.year.from_now
      }
    end
    token
  end

  def load_order
    @order ||= Order.get_incomplete_order(get_token, current_user)
  end
end