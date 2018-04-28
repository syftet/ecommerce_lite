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

require 'rails_helper'

RSpec.describe StockItem, type: :model do
    before(:each) do
      @stock_location = create(:stock_location)
      @product = create(:product)
      @stock_item = @stock_location.stock_item(@product.id)
    end
    describe ".set_count_on_hand" do

      it "should set value to count on hand" do
        @stock_item.set_count_on_hand(10)
        expect(@stock_item.count_on_hand).to eq(10)
        expect(@stock_item.in_stock?).to eq(true)
      end
    end

    describe ".in_stock?" do
      it "should return false" do
        expect(@stock_item.in_stock?).to eq(false)
      end
    end

    describe ".available??" do

      it "should return false" do
        expect(@stock_item.available?).to eq(false)
      end

      it "should return true" do
        expect(@stock_item.available?).to eq(false)
      end
    end
    describe ".reduce_count_on_hand_to_zero?" do
      it "should set count_on_hand_to_zero" do
        @stock_item.reduce_count_on_hand_to_zero
        expect(@stock_item.count_on_hand).to eq(0)
      end
    end

    describe ".verify_count_on_hand?" do
      it "should verify_count_on_hand" do
        expect(@stock_item.send(:verify_count_on_hand?)).to eq(false)
      end
    end

    describe ".adjust_count_on_hand" do
      it "should set count_on_hand_to" do
        @stock_item.adjust_count_on_hand(10)
        expect(@stock_item.count_on_hand).to eq(10)
      end
    end

end
