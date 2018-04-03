# == Schema Information
#
# Table name: wishlists
#
#  id         :integer          not null, primary key
#  product_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
