require 'rails_helper'

RSpec.describe Admin::VariantsController, type: :controller do

  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      @product = create(:product)
      @variant = @product.variants.create(name: Faker:: Name.name,description:"this is",is_active:true,sale_price:100.0,cost_price:20.0,code:"lo")
      sign_in(@user)
    end
    describe "GET #index" do
      it "return product.master active" do
        get :index,params:{product_id:@product.id}
        expect(assigns(:variants)).to eq(@product.variants)
      end
      it "renders the index template" do
        get :index,params:{product_id:@product.id}
        expect(response).to render_template("index")
      end
    end

    describe "GET #new" do
      it "should create a new variant" do
        get :new,params:{product_id:@product.id}
        expect(assigns(:variant)).to be_a_new(Product)
      end
      it "renders the #new view" do
        get :new,params:{product_id:@product.id}
        expect(response).to render_template("new")
      end
    end

    describe "POST #create" do
      it "should return a new page" do
        post :create,params:{product_id:@product.id,product: {name: Faker:: Name.name,description:"this is",is_active:true,sale_price:100.0,cost_price:20.0}}
        expect(response).to render_template("new")
      end
      it "should create a new product variant" do
        post :create,params:{product_id:@product.id,product: {name: Faker:: Name.name,description:"this is",is_active:true,sale_price:100.0,cost_price:20.0,code:"lolol"}}
        expect(response).to redirect_to(admin_product_variants_path(@product))
      end
    end

    describe "Put #edit" do
      it "located the requested variant" do
        put :edit,params:{id: @variant.id,product_id:@product.id}
        expect(assigns(:variant)).to eq(@variant)
      end
      it "renders the #edit view" do
        put :edit,params:{id: @variant.id,product_id:@product.id}
        expect(response).to render_template("edit")
      end
    end

    describe "PUT #update" do
      it "should update a variant" do
        put :update,params:{id: @variant.id,product_id:@product.id,product: {name:"apon"}}
        expect(response).to redirect_to(admin_product_variants_path(@product))
      end
    end
    describe "Delete #destroy" do
      it "should remove the variant" do
        delete :destroy,params:{id: @variant.id,product_id:@product.id}
        expect(response).to redirect_to(admin_product_variants_path(@product))
      end
    end
  end

  context "if user is not admin" do
    before(:each) do
      @product = create(:product)
      @variant = @product.variants.create(name: Faker:: Name.name,description:"this is",is_active:true,sale_price:100.0,cost_price:20.0,code:"lo")

    end
    it "should redirect to base url" do
      get :index,params:{product_id:@product.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      get :new,params:{product_id:@product.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      post :create,params:{product_id:@product.id,product: {name: Faker:: Name.name,description:"this is",is_active:true,sale_price:100.0,cost_price:20.0}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      put :edit,params:{id: @variant.id,product_id:@product.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      put :update,params:{id: @variant.id,product_id:@product.id,product: {name:"apon"}}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      delete :destroy,params:{id: @variant.id,product_id:@product.id}
      expect(response).to redirect_to(root_url)
    end
    end

end
