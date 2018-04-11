module Admin
  class StockTransfersController < BaseController
    before_action :set_stock_transfer, only: [:show, :edit, :update, :destroy]

    def index
      @stock_transfers = StockTransfer.all
    end

    def show
    end

    def new
    end

    def create
      products = Hash.new(0)
      params[:product].each_with_index do |product_id, i|
        products[product_id] += params[:quantity][i].to_i
      end
      stock_transfer = StockTransfer.create(reference: params[:reference])
      stock_transfer.transfer(source_location,
                              destination_location,
                              products)
      flash[:success] = t(:stock_successfully_transferred)
      redirect_to admin_stock_transfer_path(stock_transfer)
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

    def source_location
      @source_location ||= params.key?(:transfer_receive_stock) ? nil : StockLocation.find(params[:transfer_source_location_id])
    end

    def destination_location
      @destination_location ||= StockLocation.find(params[:transfer_destination_location_id])
    end

    def stock_transfer_params
      params.require(:stock_transfer).permit(:transfer_type, :reference,
                                             :source_location_id, :number,
                                             :destination_location_id)
    end
  end
end
