require 'rails_helper'

RSpec.describe Admin::StockLocationsController, type: :controller do
  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
      @stock_location = create(:stock_location)
    end
    describe "GET #index" do
      it "assigns @stock_location" do
        get :index
        expect(assigns(:stock_locations)).to eq([@stock_location])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end


    describe "GET #new" do
      it "should create a new stock_location" do
        get :new
        expect(assigns(:stock_location)).to be_a_new(StockLocation)
      end
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end
    describe "POST #create" do
      it "should create a stock_location" do
        post :create,params:{stock_location: { name:Faker::Name.name,address: Faker::Address.state ,city: Faker::Address.city,state: Faker::Address.state,zipcode: Faker::Address.zip_code,country: Faker::Address.country,phone: Faker::PhoneNumber.phone_number,active: true}}
        expect(response).to redirect_to(admin_stock_locations_path)
        expect(flash[:notice]).to match "Stock Location created successfully."
      end
    end

    describe "Put #edit" do
      it "located the requested @stock_location" do
        put :edit,params:{id: @stock_location.id}
        expect(assigns(:stock_location)).to eq(@stock_location)
      end
      it "renders the #edit view" do
        put :edit,params:{id: @stock_location.id}
        expect(response).to render_template("edit")
      end
    end
    describe "PUT #update" do
      it "should update a stock_location" do
        put :update,params:{id: @stock_location.id,stock_location: { name:Faker::Name.name,address: Faker::Address.state ,city: Faker::Address.city,state: Faker::Address.state,zipcode: Faker::Address.zip_code,country: Faker::Address.country,phone: Faker::PhoneNumber.phone_number,active: true}}
        expect(response).to redirect_to(admin_stock_locations_path)
        expect(flash[:notice]).to match "Stock Location updated successfully."
      end
    end
    describe "Delete #destroy" do
      it "should remove the stock_location" do
        delete :destroy,params:{id: @stock_location}
        expect(response).to redirect_to(admin_stock_locations_path)
        expect(flash[:notice]).to match "Stock Location deleted successfully."
      end
    end
    describe "get #stock_items" do
      it "should get stock_items of stock location" do
        stock_items = @stock_location.stock_items
        get :stock_items,format: :"text/html", params:{id: @stock_location}
        expect(assigns(:stock_items)).to eq(stock_items)
      end
    end
  end

  context "if user is not admin" do
    before(:each) do
      @stock_location = create(:stock_location)
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
      post :create,params:{stock_location: { name:Faker::Name.name,address: Faker::Address.state ,city: Faker::Address.city,state: Faker::Address.state,zipcode: Faker::Address.zip_code,country: Faker::Address.country,phone: Faker::PhoneNumber.phone_number,active: true}}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      put :edit,params:{id: @stock_location.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      put :update,params:{id: @stock_location.id,stock_location: { name:Faker::Name.name,address: Faker::Address.state ,city: Faker::Address.city,state: Faker::Address.state,zipcode: Faker::Address.zip_code,country: Faker::Address.country,phone: Faker::PhoneNumber.phone_number,active: true}}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      delete :destroy,params:{id: @stock_location}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      delete :destroy,params:{id: @stock_location}
      get :stock_items,format: :"text/html", params:{id: @stock_location}
    end
    end
end
