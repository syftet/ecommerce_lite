class Api::V1::RegistrationsController < Api::ApiBase
  before_action :ensure_params_exist

  respond_to :json

  def create
    resource = build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      sign_in(resource)
      render :json => {:success => true, :auth_token => resource.authentication_token, id: resource.id, :type => resource.user_type, :email => resource.email}
    else
      render :json => {:success => false, error: resource.errors.first}
    end
  end

  protected

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash = {})
    resource_class.new_with_session(hash, session)
  end

  def ensure_params_exist
    return unless params[:user_login].blank?
    render json: {success: false, message: 'missing user_login parameter'}, status: 422
  end

  def resource_name
    :user
  end

  def sign_up_params
    params.require(:user_login).permit(:email, :password, :password_confirmation)
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: {success: false, message: 'Error with your login or password'}, status: 401
  end
end