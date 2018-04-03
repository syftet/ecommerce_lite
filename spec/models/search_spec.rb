require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.result' do
    before(:each) do
      @product = create(:product)
      @product2 = Product.create(name: 'apon',
                                 description: 'This is description',
                                 code: 'code2',
                                 slug: 'slug2', discountable: true)

      @product3 = Product.create(name: 'asad',
                                 description: 'This is product3',
                                 code: 'code3',
                                 slug: 'slug3')
      @product3 = Product.create(name: 'monon',
                                 description: 'This is product3',
                                 code: '23',
                                 color:"red",
                                 size:"large",
                                 sale_price:15,
                                 slug: '3223',)
    end

    it 'should return 5 product' do
      params = { product_type: 'recent', page: 1 }
      @search = Search.new(params)
      result_object = @search.result
      # p result_object
      expect(result_object.size).to eq(5)
    end

    it 'should return 1 product' do
      params = { product_type: 'sale', page: 1 }
      @search = Search.new(params)
      result_object = @search.result
      expect(result_object.size).to eq(1)
    end

    it 'should return 0 product' do
      params = { product_type: 'top_rate', page: 1 }
      @search = Search.new(params)
      result_object = @search.result
      expect(result_object.size).to eq(0)
    end

    it 'should return 1 product match with the given name' do
      params = { name: 'apon', page: 1 }
      @search = Search.new(params)
      result_object = @search.result
      p result_object
      expect(result_object.size).to eq(1)
    end

    it 'should return 1 product' do
      params = { min:10,max:20 , page: 1 }
      @search = Search.new(params)
      result_object = @search.result
      p result_object
      expect(result_object.size).to eq(1)
    end

    it 'should return 1 product' do
      params = { size:"large", page: 1 }
      @search = Search.new(params)
      result_object = @search.result
      expect(result_object.size).to eq(1)
    end
    it 'should return 1 product' do
      params = { color:'red', page: 1 }
      @search = Search.new(params)
      result_object = @search.result
      expect(result_object.size).to eq(1)
    end
  end
end
