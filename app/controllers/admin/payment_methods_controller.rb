module Admin
  class PaymentMethodsController < BaseController
    before_action :validate_payment_method_provider, only: :create
    before_action :load_data

    respond_to :html

    def create
      @payment_method = params[:payment_method].delete(:type).constantize.new(payment_method_params)
      if @payment_method.save
        flash[:success] = t(:successfully_created, resource: t(:payment_method))
        redirect_to edit_admin_payment_method_path(@payment_method)
      else
        respond_with(@payment_method)
      end
    end

    def edit
      @payment_method = PaymentMethod.find_by_id(params[:id])
    end

    def new
      @payment_method = PaymentMethod.new
    end

    def index
      @payment_methods = PaymentMethod.all
    end

    def update
      @payment_method = PaymentMethod.find_by_id(params[:id])
      payment_method_type = params[:payment_method].delete(:type)
      if @payment_method['type'].to_s != payment_method_type
        @payment_method.update_columns(
            type: payment_method_type,
            updated_at: Time.current,
        )
        @payment_method = PaymentMethod.find(params[:id])
      end

      update_params = params[ActiveModel::Naming.param_key(@payment_method)].nil? ? {} : params[ActiveModel::Naming.param_key(@payment_method)].permit!
      attributes = payment_method_params.merge({preferences: update_params})

      if @payment_method.update_attributes(attributes)
        flash[:success] = t(:successfully_updated, resource: t(:payment_method))
        redirect_to edit_admin_payment_method_path(@payment_method)
      else
        invoke_callbacks(:update, :fails)
        respond_with(@payment_method)
      end
    end

    private

    def load_data
      @providers = [PaymentMethod::Cash,
                    PaymentMethod::StoreCredit,
                    PaymentMethod::CreditPoint,
                    PaymentMethod::PayPalExpress] #Gateway.providers.sort { |p1, p2| p1.name <=> p2.name }
    end

    def validate_payment_method_provider
      valid_payment_methods = ['PaymentMethod::Cash',
                               'PaymentMethod::StoreCredit',
                               'PaymentMethod::CreditPoint',
                               'PaymentMethod::PayPalExpress']
      if !valid_payment_methods.include?(params[:payment_method][:type])
        flash[:error] = t(:invalid_payment_provider)
        redirect_to new_admin_payment_method_path
      end
    end

    def payment_method_params
      params.require(:payment_method).permit!
    end
  end
end