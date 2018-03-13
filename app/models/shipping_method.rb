class ShippingMethod < ApplicationRecord

  has_many :shipping_rates, inverse_of: :shipping_method
  has_many :shipments, through: :shipping_rates

end