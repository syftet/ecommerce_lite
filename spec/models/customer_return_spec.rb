# == Schema Information
#
# Table name: customer_returns
#
#  id                :integer          not null, primary key
#  number            :string(255)
#  stock_location_id :integer
#  order_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe CustomerReturn, type: :model do
end
