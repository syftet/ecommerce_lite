# == Schema Information
#
# Table name: line_items
#
#  id               :integer          not null, primary key
#  variant_id       :integer
#  order_id         :integer
#  quantity         :integer
#  price            :float(24)        default(0.0)
#  cost_price       :float(24)        default(0.0)
#  currency         :string(255)
#  adjustment_total :decimal(10, )    default(0)
#  promo_total      :decimal(10, )    default(0)
#  size             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, foreign_key: 'variant_id'
  has_many :return_items

  def total
    quantity * price
  end
end
