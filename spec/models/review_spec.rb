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

require 'rails_helper'

RSpec.describe Review, type: :model do

  describe ".set_review" do
    it "should set text depends on review" do
     review = Review.create(rating: 2)
     review.set_review
      expect(review.text).to eq('Fair')
    end

    it "should not save text " do
      review = Review.create(rating: 2,text:"text")
      review.set_review
      expect(review.text).to eq('text')
    end
  end

end
