require 'rails_helper'

RSpec.describe WishlistsController, type: :controller do

  describe "Post #create" do
    before(:each) do
      @product = create(:product)

    end
    it "renders to the login when user is not authenticat" do
      post :create, params:{product_id: @product.id}
      expect(response).to redirect_to("#{root_path}#login")
    end
    it "render templete to create" do
      @user = create(:user)
      sign_in(@user)
      post :create, format: :js, params:{product_id: @product.id}
      expect(@user.wishlists.first.product).to eq(@product)

    end
  end

end
