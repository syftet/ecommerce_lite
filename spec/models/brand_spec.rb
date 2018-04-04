require 'rails_helper'

RSpec.describe Admin::Brand, type: :model do

  describe ".set_permalink" do
    it "should update the permalink coloum" do
      brand = Admin::Brand.create(name:"apple")
      expect(brand.permalink).to eq(brand.slug)
    end
  end

  describe "check_product" do
    it "should return true" do
      brand = Admin::Brand.create(name:"apple")
      expect(brand.send(:check_product)).to eq(true)
    end
  end

end
