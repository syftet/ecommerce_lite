require 'rails_helper'

RSpec.describe Admin::ShippingMethodsController, type: :controller do

  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
      @shipping_method = create(:shipping_method)
    end
    describe "GET #index" do
      it "assigns @shipping_method" do
        get :index
        expect(assigns(:shipping_methods)).to eq([@shipping_method])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    describe "GET #new" do
      it "should create a new shipping_method" do
        get :new
        expect(assigns(:shipping_method)).to be_a_new(ShippingMethod)
      end
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end
    describe "POST #create" do
      it "should create a shipping_method" do
        post :create,params:{shipping_method: {name: Faker:: Name.name, display_on: "display_on",admin_name:Faker::Name.name}}
        expect(response).to redirect_to(edit_admin_shipping_method_path(ShippingMethod.last))
      end
    end
    describe "Put #edit" do
      it "located the requested @shipping_method" do
        put :edit,params:{id: @shipping_method.id}
        expect(assigns(:shipping_method)).to eq(@shipping_method)
      end
      it "renders the #edit view" do
        put :edit,params:{id: @shipping_method.id}
        expect(response).to render_template("edit")
      end
    end

    describe "PUT #update" do
      it "should update a shipping_method" do
        put :update,params:{id: @shipping_method.id,shipping_method: {name: Faker:: Name.name, display_on: "display_on",admin_name:Faker::Name.name}}
        expect(response).to redirect_to(edit_admin_shipping_method_path(@shipping_method))
        expect(flash[:success]).to match "Shipping method updates"
      end
    end

    describe "Delete #destroy" do
      it "should remove the shipping_method" do
        delete :destroy,params:{id: @shipping_method.id}
        expect(response).to redirect_to(admin_shipping_methods_path)
        expect(flash[:success]).to match "successfully removed"
      end
    end
  end

  context "if user is not admin" do
    before(:all) do
      @shipping_method = create(:shipping_method)
    end
    it "should redirect to base url" do
      get :index
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      get :new
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      post :create,params:{shipping_method: {name: Faker:: Name.name, display_on: "display_on",admin_name:Faker::Name.name}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      put :edit,params:{id: @shipping_method.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      put :update,params:{id: @shipping_method.id,shipping_method: {name: Faker:: Name.name, display_on: "display_on",admin_name:Faker::Name.name}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      delete :destroy,params:{id: @shipping_method.id}
      expect(response).to redirect_to(root_url)
    end
    end

end
