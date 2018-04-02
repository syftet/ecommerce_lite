require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '.master?' do
    it 'should return true when product is not present' do
      product = Product.new
      expect(product.master?).to eq(true)
    end
  end
  describe '.variant?' do
    it 'should return true when product is present' do
      @p = Product.create
      @p.create_product
      expect(@p.variant?).to eq(true)
    end
  end

  describe '#generate_code' do
    it 'should return last product id+1 ' do
      @p = Product.create
      product = Product.generate_code
      expect(product).to eq('P001')
    end
  end

  describe '.on_stock' do
    it 'should return out of stock ' do
      @product = Product.create
      expect(@product.on_stock).to eq("<span class='product-out-stock'> Out Of Stock </span>")
    end

    it 'should return In Stock ' do
      @product = create(:product)
      @stock_location = create(:stock_location)
      @stock_item = @product.stock_items.create(stock_location: @stock_location)

      expect(@product.on_stock).to eq("<span class='product-in-stock'> In Stock </span>")
    end
  end

  describe '.price' do
    it 'should return sale price ' do
      product = Product.create(sale_price: 10)
      expect(product.price).to eq(10)
    end
  end

  it '.flat_discount' do
    product = Product.create(sale_price: 10,discount:5.0)
    expect(product.flat_discount).to eq(5.0)
  end

  describe '.discount_price' do
    it 'should return flate amount' do
      product = Product.create(sale_price: 10,discount:5.0,is_amount:true)
      expect(product.discount_price).to eq(5.0)
    end

    it 'should return percentage_discount ' do
      product = Product.create(sale_price: 10,discount:5.0,is_amount:false)
      expect(product.discount_price).to eq(product.percentage_discount)
    end
  end

  describe '.discount_amount' do
    it 'should return 0' do
      product = Product.create(sale_price: 10,discount:5.0,discountable:false)
      expect(product.discount_amount).to eq(0)
    end

    it 'should return discount ' do
      product = Product.create(sale_price: 10,discount:5.0,discountable:true,is_amount:true)
     expect(product.discount_amount).to eq(5.0)
    end

    it 'should return sale_price * (discount / 100.0) ' do
      product = Product.create(sale_price: 10,discount:5.0,discountable:true,is_amount:false)
      expect(product.discount_amount).to eq((product.sale_price * (product.discount / 100.0)))
    end
  end

  it '.percentage_discount ' do
    product = Product.create(sale_price: 10,discount:5.0,discountable:true,is_amount:false)
    expect(product.percentage_discount).to eq( product.sale_price - (product.sale_price * (product.discount / 100.0)))
  end

  describe ".total_on_hand" do
    it "should return totla stock_items" do
    product = Product.create
      expect(product.total_on_hand).to eq(0)
    end
  end



end
