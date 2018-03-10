class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, foreign_key: 'variant_id'

  def total
    quantity * price
  end
end