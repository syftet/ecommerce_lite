require 'rails_helper'

RSpec.describe Admin::Category, type: :model do

  describe ".set_permalink" do
    it "should update the permalink coloum" do
      category = Admin::Category.create
      expect(category.permalink).to eq(category.slug)
    end
  end

  describe "#self.menu" do
    it "should return nill" do
      category = Admin::Category.create
      categor  = Admin::Category.menu
      expect(categor.first.id).to eq(category.id)
    end
  end

end
