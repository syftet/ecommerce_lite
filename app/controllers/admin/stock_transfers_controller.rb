module Admin
  class StockTransfersController < BaseController
    before_action :set_stock_transfer, only: [:edit, :update, :destroy]

    def index
      @stock_transfers = StockTransfer.all
    end

    def new
      @stock_transfer = StockTransfer.new
    end

    def create
      @stock_transfer = StockTransfer.new(stock_transfer_params)
      respond_to do |format|
        if @stock_transfer.save
          format.html { redirect_to admin_stock_transfers_path, notice: 'Stock Transfer created successfully.' }
        else
          format.html { render :new }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @stock_transfer.update(stock_transfer_params)
          format.html { redirect_to admin_stock_transfers_path, notice: 'Stock Transfer updated successfully.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      if @stock_transfer.destroy
        flash[:notice] = 'Stock Transfer deleted successfully.'
      else
        flash[:error] = 'Unable to deleted Stock Transfer.'
      end
      redirect_to admin_stock_transfers_path
    end

    private

    def set_stock_transfer
      @stock_transfer = StockTransfer.find(params[:id])
    end

    def stock_transfer_params
      params.require(:stock_transfer).permit(:transfer_type, :reference,
                                             :source_location_id, :number,
                                             :destination_location_id)
    end
  end
end
