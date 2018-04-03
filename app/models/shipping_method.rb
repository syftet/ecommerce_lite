# == Schema Information
#
# Table name: shipping_methods
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  display_on   :string(255)
#  deleted_at   :datetime
#  admin_name   :string(255)
#  code         :string(255)
#  tracking_url :string(255)
#  rate         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ShippingMethod < ApplicationRecord

  has_many :shipping_rates, inverse_of: :shipping_method
  has_many :shipments, through: :shipping_rates

end
