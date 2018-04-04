require 'rails_helper'

RSpec.describe OrderContents, type: :model do
 describe ".add" do
   before(:each) do
    @order = Order.create
    @product = create(:product)
   end
  it "should add line item to order" do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
    expect(@order.line_items.size).to eq(1)
  end

   it "should match the product id with line item variant_id" do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
     expect(@order.line_items.first.variant_id).to eq(@product.id)
   end
 end

 describe ".remove" do
   before(:each) do
     @order = Order.create
     @product = create(:product)
   end
   it "should remove line item from order" do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
     orderContens.add(@product)
     orderContens.remove(@product)
     expect(@order.line_items.size).to eq(1)
   end
 end

 describe ".remove_line_item" do
   before(:each) do
     @order = Order.create
     @product = create(:product)
   end
   it "should remove line item " do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
     orderContens.remove_line_item(@order.line_items.first)
     expect(@order.line_items.size).to eq(0)
   end
 end

 describe ".after_add_or_remove" do
   before(:each) do
     @order = Order.create
     @product = create(:product)
   end
   it "should return line item " do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
    lineItem = orderContens.send(:after_add_or_remove ,@order.line_items.first)
     expect(@order.line_items.first).to eq(lineItem)
   end
 end

 describe ".order_updater" do
   before(:each) do
     @order = Order.create
     @product = create(:product)
   end
   it "should create Order updater " do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
     orderUpdater = orderContens.send(:order_updater)
     expect(orderUpdater.class).to eq(OrderUpdater)
   end
 end

 describe ".persist_totals" do
   before(:each) do
     @order = Order.create
     @product = create(:product)
   end
   it "should set line item count to order " do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
     orderContens.send(:persist_totals)
     expect(@order.item_count).to eq(1)
   end
 end


 describe ".add_to_line_item" do
   before(:each) do
     @order = Order.create
     @product = create(:product)
   end
   it "should add to line items" do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
     orderContens.add(@product)
     orderContens.send(:add_to_line_item,@product,2)
     expect(@order.line_items.first.quantity).to eq(4)
   end
 end

 describe ".remove_from_line_item" do
   before(:each) do
     @order = Order.create
     @product = create(:product)
   end
   it "should remove from line items" do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
     orderContens.add(@product)
     orderContens.send(:remove_from_line_item,@product,1)
     expect(@order.line_items.first.quantity).to eq(1)
   end
 end

 describe ".grab_line_item_by_variant" do
   before(:each) do
     @order = Order.create
     @product = create(:product)
   end
   it "should railse an error" do
     orderContens = OrderContents.new(@order)
     orderContens.add(@product)
     expect(orderContens.send(:grab_line_item_by_variant,@product)).to eq(@order.line_items.first)
   end
 end

end
