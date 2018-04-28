# == Schema Information
#
# Table name: refunds
#
#  id         :integer          not null, primary key
#  payment_id :integer
#  amount     :decimal(10, )
#  reason     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Refund, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
