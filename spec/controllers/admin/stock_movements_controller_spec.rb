require 'rails_helper'

RSpec.describe Admin::StockMovementsController, type: :controller do
  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
      @stock_location = create(:stock_location)
      @product =create(:product)
      @stock_item = StockItem.find_by_product_id(@product.id)
    end
    describe "GET #index" do
      it "assigns @stock_movements" do
        get :index,params:{stock_location_id:@stock_location.id}
        expect(assigns(:stock_movements)).to eq(@stock_location.stock_movements)
      end
      it "renders the index template" do
        get :index,params:{stock_location_id:@stock_location.id}
        expect(response).to render_template("index")
      end
    end

    describe "GET #new" do
      it "should create a new admin stock_movements" do
        get :new,params:{stock_location_id:@stock_location.id}
        expect(assigns(:stock_movement)).to be_a_new(StockMovement)
      end
      it "renders the #new view" do
        get :new,params:{stock_location_id:@stock_location.id}
        expect(response).to render_template("new")
      end
    end
    describe "POST #create" do
      it "should create a stock_movements" do
        post :create,params:{stock_location_id:@stock_location.id,stock_movement: {quantity:4,stock_item_id:@stock_item.id }}
        expect(response).to redirect_to(admin_stock_location_stock_movements_path(@stock_location))
        expect(flash[:notice]).to match "Stock movement created successfully."
      end
    end

    describe "Put #edit" do
      it "located the requested @stock_movements" do
        stock_movement = StockMovement.create(quantity:4,stock_item_id:@stock_item.id)
        put :edit,params:{id: stock_movement.id,stock_location_id:@stock_location.id}
        expect(assigns(:stock_movement)).to eq(stock_movement)
      end
      it "renders the #edit view" do
        stock_movement = StockMovement.create(quantity:4,stock_item_id:@stock_item.id)
        put :edit,params:{id: stock_movement.id,stock_location_id:@stock_location.id}
        expect(response).to render_template("edit")
      end
    end

  end

  context "if user is not admin" do
    before(:all) do
      @stock_location = create(:stock_location)
      @product =create(:product)
      @stock_item = StockItem.find_by_product_id(@product.id)
  end
    it "should redirect to base url" do
      get :index,params:{stock_location_id:@stock_location.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      get :new,params:{stock_location_id:@stock_location.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      stock_movement = StockMovement.create(quantity:4,stock_item_id:@stock_item.id)
      put :edit,params:{id: stock_movement.id,stock_location_id:@stock_location.id}
      expect(response).to redirect_to(root_url)
    end
    end
end
