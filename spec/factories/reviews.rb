# == Schema Information
#
# Table name: reviews
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  rating      :integer
#  text        :text(65535)
#  product_id  :integer
#  user_id     :integer
#  email       :string(255)
#  is_approved :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :review do
    
  end
end
