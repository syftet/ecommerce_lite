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
