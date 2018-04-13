module Admin
  class StockItemsController < BaseController
    before_action :set_stock_item, only: [:update, :destroy]

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
      redirect_to stock_admin_product_path(product)
    end

    def update
      respond_to do |format|
        if @stock_item.update(stock_item_params)
          format.html { redirect_to stock_admin_product_path(@stock_item.product), notice: 'Stock changed successfully.' }
        else
          format.html { redirect_to stock_admin_product_path(@stock_item.product), error: 'Unable to changed stock.' }
        end
      end
    end

    def destroy
      respond_to do |format|
        @product = @stock_item.product.master? ? @stock_item.product : @stock_item.product.product
        if @stock_item.destroy
          format.html { redirect_to stock_admin_product_path(@product), notice: 'Stock changed successfully.' }
        else
          format.html { redirect_to stock_admin_product_path(@product), error: 'Unable to changed stock.' }
        end
      end
    end

    private

    def set_stock_item
      @stock_item = StockItem.find(params[:id])
    end

    def stock_item_params
      params.require(:stock_item).permit!
    end

    def stock_movement_params
      params.require(:stock_movement).permit!
    end
  end
end
