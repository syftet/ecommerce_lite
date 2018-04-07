require 'rails_helper'

RSpec.describe Admin::BrandsController, type: :controller do

  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
    end
    describe "GET #index" do
      it "assigns @brand" do
        brand = create(:admin_brand)
        get :index
        expect(assigns(:admin_brands)).to eq([brand])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    describe "GET #show" do
      it "assigns the requested brand to @brand" do
        brand = create(:admin_brand)
        get :show, params:{id: brand.id}
        expect(assigns(:admin_brand)).to eq(brand)
      end
      it "renders the #show view" do
        brand = create(:admin_brand)
        get :show, params:{id: brand.id}
        expect(response).to render_template("show")
      end
    end
    describe "GET #new" do
      it "should create a new admin brand" do
        get :new
        expect(assigns(:admin_brand)).to be_a_new(Admin::Brand)
      end
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "Put #edit" do
      it "located the requested @brand" do
        brand = create(:admin_brand)
        put :edit,params:{id: brand.id}
        expect(assigns(:admin_brand)).to eq(brand)
      end
      it "renders the #edit view" do
        brand = create(:admin_brand)
        put :edit,params:{id: brand.id}
        expect(response).to render_template("edit")
      end
    end

    describe "POST #create" do
      it "should create a brand" do
        post :create,params:{admin_brand: {name: Faker:: Name.name}}
        expect(response).to redirect_to(admin_brand_path(Admin::Brand.last))
      end
    end

    describe "PUT #update" do
      it "should update a brand" do
        brand = create(:admin_brand)
        put :update,params:{id: brand.id,admin_brand: {name:"apon"}}
        expect(response).to redirect_to(admin_brand_path(Admin::Brand.last))
      end
    end

    describe "Delete #destroy" do
      it "should remove the brand" do
        brand = create(:admin_brand)
        delete :destroy,params:{id: brand.id}
        expect(response).to redirect_to(admin_brands_url)
      end
    end
  end

  context "if user is not admin" do
    it "should redirect to base url" do
      get :index
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      brand = create(:admin_brand)
      get :show, params:{id: brand.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      get :new
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      brand = create(:admin_brand)
      put :edit,params:{id: brand.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      brand = create(:admin_brand)
      put :edit,params:{id: brand.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      post :create,params:{admin_brand: {name: Faker:: Name.name}}
      expect(response).to redirect_to(root_url)
    end

    it "should redirect to base url" do
      brand = create(:admin_brand)
      put :update,params:{id: brand.id,admin_brand: {name:"apon"}}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      brand = create(:admin_brand)
      delete :destroy,params:{id: brand.id}
      expect(response).to redirect_to(root_url)
    end
    end
end
