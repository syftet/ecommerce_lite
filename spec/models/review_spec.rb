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
