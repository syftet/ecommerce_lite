require 'rails_helper'

RSpec.describe Admin::StockItemsController, type: :controller do

  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
      @product = create(:product)
      @stock_location = StockLocation.create(name:Faker::Name.name)
      @stock_item = StockItem.find_by_product_id(@product.id)
    end

    describe "POST #create" do
      it "should create a category" do
        post :create,params:{product_id:@product.id,stock_location_id:@stock_location.id,stock_movement: {quantity:20,action: "action"}}
        expect(response).to redirect_to(admin_products_path)
        expect(flash[:success]).to match "Stock successfully added."
      end
    end
    describe "PUT #update" do
      it "should update a stock_item" do
        put :update,params:{id: @stock_item.id,stock_item: {count_on_hand:22}}
        expect(response).to redirect_to(stock_admin_product_path(@stock_item.product))
        expect(flash[:notice]).to match "Stock changed successfully."
        end
    end
    describe "Delete #destroy" do
      it "should remove the stock_item" do
        delete :destroy,params:{id: @stock_item.id}
        expect(response).to redirect_to(stock_admin_product_path(@product))
        expect(flash[:notice]).to match "Stock changed successfully."

      end
    end
    end

  context "if user is not admin" do
    before(:each) do
      @product = create(:product)
      @stock_location = StockLocation.create(name:Faker::Name.name)
      @stock_item = StockItem.find_by_product_id(@product.id)
    end
    it "should redirect to base url" do
        post :create,params:{product_id:@product.id,stock_location_id:@stock_location.id,stock_movement: {quantity:20,action: "action"}}
        expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
        put :update,params:{id: @stock_item.id,stock_item: {count_on_hand:22}}
        expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      delete :destroy,params:{id: @stock_item.id}
        expect(response).to redirect_to(root_url)
    end
    end

end
