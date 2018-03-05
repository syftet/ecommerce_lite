class Users::SessionsController < Devise::SessionsController
  include Core::ControllerHelpers::StoreHelper
  include Core::ControllerHelpers::OrderHelper
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    respond_to do |format|
      format.html {
        super
      }
      format.js {}
    end
  end

  # POST /resource/sign_in
  def create
    @error = ''
    resource = User.find_for_database_authentication(email: params[:user][:email])
    if resource
      if resource.valid_password?(params[:user][:password])
        sign_in :user, resource
        @sing_in_path = after_sign_in_path_for(resource)
      else
        @error = 'Invalid password'
      end
    else
      @error = 'Invalid email'
    end
    set_flash_message(:alert, :invalid) unless @error.empty?
    respond_to do |format|
      format.js {
        render layout: false
      }
      format.html {
        redirect_to after_sign_in_path_for(resource)
      }
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
