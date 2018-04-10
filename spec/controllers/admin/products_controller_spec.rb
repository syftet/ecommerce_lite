require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do

  context "if user is admin" do
    before(:each) do
      user = create(:user)
      sign_in(user)
      @product = create(:product)
    end

    describe "GET #index" do
      it "return product.master active" do
        get :index
        expect(assigns(:products)).to eq([@product])
      end
      it "return all product" do
        get :index,format: :json,xhr: true
        expect(Product.count).to eq(1)
      end
    end

    describe "GET #new" do
      it "should create a new product" do
        get :new
        expect(assigns(:product)).to be_a_new(Product)
      end
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "POST #create" do
      it "should return a new page" do
        post :create,params:{product: {name: Faker:: Name.name,description:"this is",is_active:true,sale_price:100.0,cost_price:20.0}}
        expect(response).to render_template("new")
      end
      it "should create a new product" do
        post :create,params:{product: {name: Faker:: Name.name,description:"this is",is_active:true,sale_price:100.0,cost_price:20.0,code:"lol"}}
        expect(response).to redirect_to(edit_admin_product_path(Product.last))
      end
    end

    describe "Put #edit" do
      it "located the requested @product" do
        put :edit,params:{id: @product.id}
        expect(assigns(:product)).to eq(@product)
      end
      it "renders the #edit view" do
        put :edit,params:{id: @product.id}
        expect(response).to render_template("edit")
      end
    end

    describe "PUT #update" do
      it "should update a product" do
        put :update,params:{id: @product.id,product: {name:"apon"}}
        expect(response).to redirect_to(edit_admin_product_path(@product))
      end
    end

    describe "Delete #destroy" do
      it "should remove the product" do
        delete :destroy,params:{id: @product.id}
        expect(response).to redirect_to(admin_products_path)
      end
    end
    describe "get #stock" do
      it "should redirct" do
        get :stock,params:{id: @product.id}
        expect(response).to redirect_to(admin_stock_locations_path)
      end
    end
  end

  context "if user is not admin" do
    before(:each) do
      @product = create(:product)
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
      post :create,params:{product: {name: Faker:: Name.name,description:"this is",is_active:true,sale_price:100.0,cost_price:20.0,code:"lol"}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      put :edit,params:{id: @product.id}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      put :update,params:{id: @product.id,product: {name:"apon"}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      delete :destroy,params:{id: @product.id}
      expect(response).to redirect_to(root_url)
    end
  end
end
