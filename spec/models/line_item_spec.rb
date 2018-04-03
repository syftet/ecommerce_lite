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

require 'rails_helper'

RSpec.describe LineItem, type: :model do


  it "returns total by multiplaction qunatity and price" do
    lineItem = LineItem.new(
        quantity: 2,
        price: 5.5
    )
    expect(lineItem.total).to eq(11)
  end

end
