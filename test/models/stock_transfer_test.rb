# == Schema Information
#
# Table name: stock_transfers
#
#  id                      :integer          not null, primary key
#  transfer_type           :string(255)
#  reference               :string(255)
#  source_location_id      :integer
#  destination_location_id :integer
#  number                  :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'test_helper'

class StockTransferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
