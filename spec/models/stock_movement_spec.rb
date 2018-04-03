require 'rails_helper'

RSpec.describe StockMovement, type: :model do

  describe ".readonly?" do
    it "should return false" do
      stockMovement = StockMovement.new
      expect(stockMovement.readonly?).to eq(false)
    end
  end

end
