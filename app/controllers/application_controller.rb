class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_order

  def current_order(create_order = false)
    order = Order.get_incomplete_order(get_token, current_user)
    if create_order && order.blank?
      order = Order.new
      order.guest_token = get_token
      order.user_id = current_user.id if current_user.present?
      order.state = 'address'
      order.save!
    end
    order
  end

  def get_token
    token = cookies[:guest_token]
    unless token.present?
      token = SecureRandom.urlsafe_base64(nil, false)
      cookies[:guest_token] = token
    end
    token
  end

  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up)
  end
end
