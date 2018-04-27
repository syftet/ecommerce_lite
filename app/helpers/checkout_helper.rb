module CheckoutHelper

  def check_selected_shipment(order, ship_method_id)
    if order.shipment.present?
      order.shipment.shipping_method.present? ? order.shipment.shipping_method_id == ship_method_id : false
    else
      false
    end
  end
end