class Api::V1::LineItemsController < Api::ApiBase

  def remove_item
    error = ''
    total = 0.0
    total_item = 0
    line_item = LineItem.find_by_id(params[:item_id])
    if line_item.present?
      begin
        order = line_item.order
        order.contents.remove_line_item(line_item, {})
        total = order.net_total
        total_item = order.item_count
      rescue => e
        error = e.message.to_s
      end
    else
      error = 'Item not found.'
    end

    render json: {
      status: !error.present?,
      error: error,
      total: total,
      total_item: total_item
    }
  end
end
