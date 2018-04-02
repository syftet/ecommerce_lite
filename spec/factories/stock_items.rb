FactoryBot.define do
  factory :stock_item do
    product_id 10
    stock_location
  end

  factory :stock_location do
    name 'apon'
  end
end
