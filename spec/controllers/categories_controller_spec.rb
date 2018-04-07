require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  describe "GET #show" do
    before(:each) do
      @category = Admin::Category.create(name: Faker::Name.first_name,description:"this is description")
    end
    it "should respons " do
      get :show ,params:{product_id: @category.permalink}
      expect(response.status).to eq(200)
      end
    it "should respons html format" do
      get :show ,params:{id: @category.permalink}
      expect(response.content_type).to eq "text/html"
    end
  end

end
