require 'rails_helper'

RSpec.describe Product, type: :model do

  describe ".master?" do
    it "should return true when product is not present" do
      product = Product.new
      expect(product.master?).to eq(true)
    end
  end
  describe ".variant?" do
    it "should return true when product is present" do
      @p = Product.create()
      @p.create_product
      expect(@p.variant?).to eq(true)
    end
  end


end
