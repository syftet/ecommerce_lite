require 'rails_helper'

RSpec.describe Admin::StockTransfersController, type: :controller do
  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
      @stock_transfer = create(:stock_transfer)
    end
    describe "GET #index" do
      it "assigns @stock_transfre" do
        get :index
        expect(assigns(:stock_transfers)).to eq([@stock_transfer])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    describe "GET #show" do
      it "assigns the requested category to @stock_transfre" do
        get :show, params:{id: @stock_transfer.id}
        expect(assigns(:stock_transfer)).to eq(@stock_transfer)
      end
      it "renders the #show view" do
        get :show, params:{id: @stock_transfer.id}
        expect(response).to render_template("show")
      end
    end
    describe "GET #new" do
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end
    describe "Put #edit" do
      it "located the requested @stock_transfer" do
        put :edit,params:{id: @stock_transfer.id}
        expect(assigns(:stock_transfer)).to eq(@stock_transfer)
      end
    end
    describe "PUT #update" do
      it "should update a stock_transfer" do
        put :update,params:{id:@stock_transfer.id,stock_transfer: {transfer_type:"car",reference:"apon"}}
        expect(response).to redirect_to(admin_stock_transfers_path)
        expect(flash[:notice]).to match "Stock Transfer updated successfully."
      end
    end
    describe "Delete #destroy" do
      it "should remove the stock_transfer" do
        delete :destroy,params:{id:@stock_transfer.id}
        expect(response).to redirect_to(admin_stock_transfers_path)
        expect(flash[:notice]).to match "Stock Transfer deleted successfully."
      end
    end
  end

  context "if user is not admin" do
    before(:all) do
      @stock_transfer = create(:stock_transfer)
    end
    it "should redirect to base url" do
      get :index
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      get :show, params:{id: @stock_transfer.id}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      get :new
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      put :edit,params:{id: @stock_transfer.id}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      put :update,params:{id:@stock_transfer.id,stock_transfer: {transfer_type:"car",reference:"apon"}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      delete :destroy,params:{id:@stock_transfer.id}
      expect(response).to redirect_to(root_url)
    end
    end
end
