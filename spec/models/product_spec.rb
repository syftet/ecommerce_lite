# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  code            :string(255)      not null
#  name            :string(255)
#  description     :text(65535)
#  origin          :string(255)
#  slug            :string(255)
#  meta_title      :string(255)
#  meta_desc       :text(65535)
#  keywords        :string(255)
#  brand_id        :integer
#  is_featured     :boolean          default(FALSE), not null
#  is_active       :boolean          default(TRUE), not null
#  deleted_at      :datetime
#  product_id      :integer
#  sale_price      :float(53)        default(0.0), not null
#  cost_price      :float(53)        default(0.0), not null
#  whole_sale      :float(53)        default(0.0), not null
#  color_name      :string(255)
#  color           :string(255)
#  size            :string(255)
#  weight          :string(255)
#  width           :string(255)
#  height          :string(255)
#  depth           :string(255)
#  discountable    :boolean          default(FALSE)
#  is_amount       :boolean          default(FALSE)
#  discount        :float(53)        default(0.0), not null
#  reward_point    :float(53)        default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  track_inventory :boolean          default(TRUE)
#  pos_id          :integer
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#

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
     # @stock_item = @product.stock_items.create(stock_location: @stock_location)

      expect(@product.on_stock).to eq("<span class='product-out-stock'> Out Of Stock </span>")
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
