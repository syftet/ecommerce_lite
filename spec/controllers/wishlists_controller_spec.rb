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

  describe "Delete #destroy" do
    before(:each) do
      @product = create(:product)

    end
    it "renders to the login when user is not authenticat" do
      post :create, params:{product_id: @product.id}
      expect(response).to redirect_to("#{root_path}#login")
    end
    it "remove the wishlist" do
      @user = create(:user)
      sign_in(@user)
      post :create, format: :js, params:{product_id: @product.id}
      delete :destroy,format: :js, params:{id: @user.wishlists.first.id}
      expect(@user.wishlists.size).to eq(0)

    end
  end

  describe "GET #index" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
    end
    it "get the @wishlist" do
      wishlists = @user.wishlists
      get :index
      expect(assigns(:wishlists)).to eq(@user.wishlists)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

end
