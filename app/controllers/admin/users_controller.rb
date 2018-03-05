module Admin
  class UsersController < BaseController

    def index
      @users = User.all
      respond_to do |format|
        format.html
        format.json { render :json => json_data }
      end
    end

    def show
      redirect_to edit_admin_user_path(@user)
    end

    def create
      @user = User.new(user_params)
      if @user.save
        flash.now[:success] = flash_message_for(@user, :successfully_created)
        render :edit
      else
        render :new
      end
    end

    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      if @user.update_attributes(user_params)
        flash.now[:success] = t(:account_updated)
      end

      render :edit
    end

    def login
      user = User.find_by_id(params[:id])
      current_user = user
      current_user.reload
      sign_in :user, current_user
      current_user.reload
      redirect_to root_path
    end

    def addresses
      if request.put?
        if @user.update_attributes(user_params)
          flash.now[:success] = t(:account_updated)
        end

        render :addresses
      end
    end

    def orders
      params[:q] ||= {}
      @search = Order.reverse_chronological.ransack(params[:q].merge(user_id_eq: @user.id))
      @orders = @search.result.page(params[:page]).per(Syftet.config.admin_products_per_page)
    end

    def items
      params[:q] ||= {}
      @search = Order.includes(
          line_items: {
              variant: [:product, {option_values: :option_type}]
          }).ransack(params[:q].merge(user_id_eq: @user.id))
      @orders = @search.result.page(params[:page]).per(Syftet.config.admin_products_per_page)
    end

    def generate_api_key
      if @user.generate_syftet_api_key!
        flash[:success] = t('api.key_generated')
      end
      redirect_to edit_admin_user_path(@user)
    end

    def clear_api_key
      if @user.clear_spree_api_key!
        flash[:success] = Spree.t('api.key_cleared')
      end
      redirect_to edit_admin_user_path(@user)
    end

    def model_class
      User
    end

    protected

    def collection
      return @collection if @collection.present?
      @collection = super
      if request.xhr? && params[:q].present?
        @collection = @collection.includes(:bill_address, :ship_address)
                          .where("spree_users.email #{LIKE} :search
                                     OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                     OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                     OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)
                                     OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)",
                                 {:search => "#{params[:q].strip}%"})
                          .limit(params[:limit] || 100)
      else
        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(Syftet.config.admin_product_per_page)
      end
    end

    private

    def user_params
      params.require(:user).permit(permitted_user_attributes |
                                       [role_user_ids: [],
                                        ship_address_attributes: permitted_address_attributes,
                                        bill_address_attributes: permitted_address_attributes])
    end

    # handling raise from Admin::ResourceController#destroy
    def user_destroy_with_orders_error
      invoke_callbacks(:destroy, :fails)
      render status: :forbidden, text: Spree.t(:error_user_destroy_with_orders)
    end

    # Allow different formats of json data to suit different ajax calls
    def json_data
      json_format = params[:json_format] || 'default'
      case json_format
        when 'basic'
          collection.map { |u| {'id' => u.id, 'name' => u.email} }.to_json
        else
          address_fields = [:firstname, :lastname, :address1, :address2, :city, :zipcode, :phone, :state_name, :state_id, :country_id]
          includes = {only: address_fields, include: {state: {only: :name}, country: {only: :name}}}

          collection.to_json(only: [:id, :email], include:
                                                    {bill_address: includes, ship_address: includes})
      end
    end

    def sign_in_if_change_own_password
      if current_user == @user && @user.password.present?
        sign_in(@user, event: :authentication, bypass: true)
      end
    end
  end
end