require 'rails_helper'

RSpec.describe Admin::ImagesController, type: :controller do

  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      @product = create(:product)
      @image = create(:image,viewable:@product)

      sign_in(@user)
    end
    describe "GET #index" do
      it "assigns @images" do
        images = @product.images
        get :index ,params:{product_id:@product.id}
        expect(assigns(:images)).to eq(images)
      end
      it "renders the index template" do
        get :index,params:{product_id:@product.id}
        expect(response).to render_template("index")
      end
    end
    describe "GET #new" do
      it "should create a new admin image" do
        get :new,params:{product_id:@product.id}
        expect(assigns(:image)).to be_a_new(Image)
      end
      it "renders the #new view" do
        get :new,params:{product_id:@product.id}
        expect(response).to render_template("new")
      end
    end

    describe "POST #create" do
      it "should create a image" do
        post :create,params:{product_id:@product.id,image: {width: 20,height:10, file:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
        expect(response).to redirect_to(admin_product_images_path(@product))
      end
    end
    describe "Put #edit" do
      it "located the requested @image" do
        put :edit,params:{id: @image.id,product_id:@product.id}
        expect(assigns(:image)).to eq(@image)
      end
    end

    describe "PUT #update" do
      it "should update a image" do
        put :update,params:{id: @image.id,product_id:@product.id,image: {width: 5,height:5, file:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
        expect(response).to redirect_to(admin_product_images_path(@product))
      end
    end

    describe "Delete #destroy" do
      it "should remove the image" do
        delete :destroy,params:{id: @image.id,product_id:@product.id}
        expect(response).to redirect_to(admin_product_images_path(@product))
      end
    end
  end

  context "if user is not admin" do
    before(:each) do
      @user = create(:user)
      @product = create(:product)
      @image = create(:image,viewable:@product)
    end
    it "should redirect to base url" do
      get :index ,params:{product_id:@product.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      get :new,params:{product_id:@product.id}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      post :create,params:{product_id:@product.id,image: {width: 20,height:10, file:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      put :edit,params:{id: @image.id,product_id:@product.id}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      put :update,params:{id: @image.id,product_id:@product.id,image: {width: 5,height:5, file:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      delete :destroy,params:{id: @image.id,product_id:@product.id}
      expect(response).to redirect_to(root_url)
    end
    end
end
