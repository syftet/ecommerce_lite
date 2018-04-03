# == Schema Information
#
# Table name: stock_items
#
#  id                :integer          not null, primary key
#  stock_location_id :integer
#  product_id        :integer
#  count_on_hand     :integer          default(0)
#  backorderable     :boolean          default(FALSE)
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class StockItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
