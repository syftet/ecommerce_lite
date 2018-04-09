require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do

  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
    end
    describe "GET #index" do
      it "assigns @category" do
        category = create(:category)
        get :index
        expect(assigns(:admin_categories)).to eq([category])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    describe "GET #show" do
      it "assigns the requested category to @category" do
        category = create(:category)
        get :show, params:{id: category.id}
        expect(assigns(:admin_category)).to eq(category)
      end
      it "renders the #show view" do
        category = create(:category)
        get :show, params:{id: category.id}
        expect(response).to render_template("show")
      end
    end
    describe "GET #new" do
      it "should create a new admin category" do
        get :new
        expect(assigns(:admin_category)).to be_a_new(Admin::Category)
      end
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "Put #edit" do
      it "located the requested @category" do
        category = create(:category)
        put :edit,params:{id: category.id}
        expect(assigns(:admin_category)).to eq(category)
      end
      it "renders the #edit view" do
        category = create(:category)
        put :edit,params:{id: category.id}
        expect(response).to render_template("edit")
      end
    end

    describe "POST #create" do
      it "should create a category" do
        post :create,params:{admin_category: {name: Faker:: Name.name,description: "description"}}
        expect(response).to redirect_to(admin_category_path(Admin::Category.last))
        end
    end
    describe "PUT #update" do
      it "should update a category" do
        category = create(:category)
        put :update,params:{id: category.id,admin_category: {name:"apon"}}
        expect(response).to redirect_to(admin_category_path(Admin::Category.last))
      end
    end
    describe "Delete #destroy" do
      it "should remove the category" do
        category = create(:category)
        delete :destroy,params:{id: category.id}
        expect(response).to redirect_to(admin_categories_url)
      end
    end

  end

  context "if user is not admin" do
    it "should redirect to base url" do
      get :index
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      category = create(:category)
      get :show, params:{id: category.id}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      get :new
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      category = create(:category)
      put :edit,params:{id: category.id}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      category = create(:category)
      put :update,params:{id: category.id,admin_category: {name:"apon"}}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      category = create(:category)
      delete :destroy,params:{id: category.id}
      expect(response).to redirect_to(root_url)
    end
  end
end
