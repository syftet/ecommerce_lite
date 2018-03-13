module Admin
  class StockMovementsController < BaseController
    before_action :set_stock_location

    def index
      @stock_movements = @stock_location.stock_movements.recent
    end

    def new
      @stock_movement = @stock_location.stock_movements.build
    end

    def create
      @stock_movement = @stock_location.stock_movements.build(stock_movement_params)
      respond_to do |format|
        if @stock_movement.save
          format.html { redirect_to admin_stock_location_stock_movements_path(@stock_location), notice: 'Stock movement created successfully.' }
        else
          format.html { redirect_to admin_stock_location_stock_movements_path(@stock_location), notice: 'Unable to move stock.' }
        end
      end
    end

    def edit
      @stock_movement = StockMovement.find(params[:id])
    end

    private

    def set_stock_location
      @stock_location = StockLocation.find(params[:stock_location_id])
    end

    def stock_movement_params
      params.require(:stock_movement).permit(:quantity, :stock_item_id, :action)
    end
  end
end
