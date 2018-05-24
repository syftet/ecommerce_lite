module Admin
  class DashboardController < BaseController
    def index
      @orders = Order.all.complete.order(completed_at: :desc).limit(20)
    end
  end
end
