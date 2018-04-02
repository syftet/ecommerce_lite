FactoryBot.define do
  factory :product do
    name 'Joe'
    description 'This is description'
    code 'eewerr'
    slug 'slug'
    # factory :product_with_stock_items do
    #   after(:create) do |product|
    #     p 'sdsdsd'
    #     p product.inspect
    #     p StockItem.all.inspect
    #     create(:stock_item, product_id: product.id)
    #     p 'oipiopiop'
    #   end
    # end

  end
end
