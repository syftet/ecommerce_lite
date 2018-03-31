require 'rails_helper'

RSpec.describe Address, type: :model do

  it 'returns full name removing sapace' do
    address = Address.new(
      firstname: 'John',
      lastname: 'Doe'
    )
    expect(address.full_name).to eq 'John Doe'
  end

  it 'returns to string using full name:address' do
    address = Address.new(
      firstname: 'John',
      lastname: 'Doe',
      address: 'Dohs'
    )
    expect(address.to_s).to eq 'John Doe: Dohs'
  end

  it 'should get address object' do
    address = Address.build_default
    expect(address.class).to eq Address
  end



end
