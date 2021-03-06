# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  firstname  :string(255)
#  lastname   :string(255)
#  address    :string(255)
#  city       :string(255)
#  zipcode    :string(255)
#  phone      :string(255)
#  state      :string(255)
#  company    :string(255)
#  country    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Address, type: :model do

  it 'returns full name removing space' do
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
    user = create(:user)
    address = Address.build_default(user)
    expect(address.class).to eq Address
  end



end
