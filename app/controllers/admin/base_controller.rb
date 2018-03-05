module Admin
  class BaseController < ApplicationController
    layout 'layouts/admin'

    before_action :authorize_admin

    rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = exception.message
      redirect_to root_url
    end

    protected

    def action
      params[:action].to_sym
    end

    def authorize_admin
      if respond_to?(:model_class, true) && model_class
        record = model_class
      else
        record = controller_name.to_sym
      end
      authorize! :admin, record
      authorize! action, record
    end
  end
end