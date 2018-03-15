class CartsController < ApplicationController
  layout 'product'

  def index

  end

  def update
    @order = Order.find_by_id(params[:order_id])
    @error = ''
    if @order
      @line_item = @order.line_items.find_by_id(params[:id])
      if @line_item && params[:quantity]
        add_or_remove_quantity = params[:quantity].to_i
        existing_quantity = @line_item.quantity + add_or_remove_quantity
        if add_or_remove_quantity > 0
          @line_item = @order.contents.add(@line_item.product, add_or_remove_quantity, {})
        elsif add_or_remove_quantity < 0 && existing_quantity > 0
          @line_item = @order.contents.remove(@line_item.product, add_or_remove_quantity.abs, {})
        else
          @error = "Line item quantity can't be 0"
        end
        unless @line_item.save
          @error = @line_item.errors.first
        end
      else
        @error = 'Line item not found'
      end
    else
      @error = 'Order not found'
    end
  end

  def destroy
    @line_item = LineItem.find_by_id(params[:id])
    if @line_item.present?
      begin
        order = @line_item.order
        order.contents.remove_line_item(@line_item, {})
      rescue => e
        flash[:error] = e.message
      end
    end

    respond_to do |format|
      format.html {
        redirect_to carts_path
      }
    end
  end

end