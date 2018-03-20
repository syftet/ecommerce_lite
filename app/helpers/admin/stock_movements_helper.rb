module Admin
  module StockMovementsHelper
    def pretty_originator(stock_movement)
      if stock_movement.originator.respond_to?(:number)
        if stock_movement.originator.respond_to?(:orders)
          link_to stock_movement.originator.number, [:edit, :admin, stock_movement.originator.order]
        else
          stock_movement.originator.number
        end
      else
        ''
      end
    end

    def display_variant(stock_movement)
      product = stock_movement.stock_item.product
      output = [product.name]
      # output << product.options_text unless product.options_text.blank?
      safe_join(output, '<br />'.html_safe)
    end
  end
end
