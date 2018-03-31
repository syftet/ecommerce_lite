require 'rails_helper'

RSpec.describe LineItem, type: :model do


  it "returns total by multiplaction qunatity and price" do
    lineItem = LineItem.new(
        quantity: 2,
        price: 5.5
    )
    expect(lineItem.total).to eq(11)
  end

end
