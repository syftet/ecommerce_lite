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

class Review < ApplicationRecord
  RATING_REVIEW = {
      1 => 'Poor :(',
      2 => 'Fair',
      3 => 'Average',
      4 => 'Good :)',
      5 => 'Excellent!',
  }
  belongs_to :product
  belongs_to :user
  validates_presence_of :name, :email, :rating

  before_save :set_review

  def set_review
    unless self.text.present?
      self.text = RATING_REVIEW[self.rating]
    end
  end
end
