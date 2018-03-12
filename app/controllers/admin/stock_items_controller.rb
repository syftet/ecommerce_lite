module Admin
  class StockItemsController < BaseController
    def create
      product = Product.find(params[:product_id])
      stock_location = StockLocation.find(params[:stock_location_id])
      stock_movement = stock_location.stock_movements.build(stock_movement_params)
      stock_movement.stock_item = stock_location.set_up_stock_item(product)

      if stock_movement.save
        flash[:success] = 'Stock successfully added.'
      else
        flash[:error] = 'unable to add stock'
      end

      redirect_to admin_products_path
    end

    def destroy
      stock_item.destroy

      respond_with(@stock_item) do |format|
        format.html { redirect_to :back }
        format.js
      end
    end

    private

    def stock_movement_params
      params.require(:stock_movement).permit!
    end
  end
end
