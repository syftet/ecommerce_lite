require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
    end
    it "assigns @order of user" do
      order = @user.orders
      get :my_account
      expect(assigns(:orders)).to eq(@user.orders)
    end

    it "renders the index template" do
      get :my_account
      expect(response).to render_template("my_account")
    end
  end
end
