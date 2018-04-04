require 'rails_helper'

RSpec.describe OrderUpdater, type: :model do

  describe ".update" do
    before(:each) do
      @order = Order.create
      @product = create(:product)
    end
    it "should set line item count to order " do
      orderContens = OrderContents.new(@order)
      orderContens.add(@product)
      orderUpdater = OrderUpdater.new(@order)
      orderUpdater.update
      expect(@order.item_count).to eq(1)
    end
  end

end
