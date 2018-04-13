json.array! @stock_items do |stock_item|
  if stock_item.product.present?
    json.id stock_item.product_id
    json.text "#{stock_item.product.name} - #{stock_item.product.code} (#{stock_item.count_on_hand})"
    json.name stock_item.product.name
    json.code stock_item.product.code
    json.count_on_hand stock_item.count_on_hand
  end
end