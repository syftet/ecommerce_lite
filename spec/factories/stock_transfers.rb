# == Schema Information
#
# Table name: stock_transfers
#
#  id                      :integer          not null, primary key
#  transfer_type           :string(255)
#  reference               :string(255)
#  source_location_id      :integer
#  destination_location_id :integer
#  number                  :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryBot.define do
  factory :stock_transfer do
    transfer_type "shipping"
    reference "reference"
    number Faker:: Number.digit
  end
end
