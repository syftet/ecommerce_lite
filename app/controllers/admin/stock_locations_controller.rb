module Admin
  class StockLocationsController < BaseController
    before_action :set_stock_location, only: [:edit, :update, :destroy, :stock_items]

    def index
      @stock_locations = StockLocation.all
    end

    def new
      @stock_location = StockLocation.new
    end

    def create
      @stock_location = StockLocation.new(stock_location_params)
      respond_to do |format|
        if @stock_location.save
          format.html { redirect_to admin_stock_locations_path, notice: 'Stock Location created successfully.' }
        else
          format.html { render :new }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @stock_location.update(stock_location_params)
          format.html { redirect_to admin_stock_locations_path, notice: 'Stock Location updated successfully.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      if @stock_location.destroy
        flash[:notice] = 'Stock Location deleted successfully.'
      else
        flash[:error] = 'Unable to deleted Stock Location.'
      end
      redirect_to admin_stock_locations_path
    end

    def stock_items
      @stock_items = @stock_location.stock_items
    end

    private

    def set_stock_location
      @stock_location = StockLocation.find(params[:id])
    end

    def stock_location_params
      params.require(:stock_location).permit(:name, :default, :address, :city,
                                             :state, :zipcode, :country, :phone,
                                             :active, :backorderable_default,
                                             :propagate_all_variants, :admin_name)
    end
  end
end
