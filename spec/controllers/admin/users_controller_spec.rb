require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
    end
    describe "GET #index" do
      it "assigns @users" do
        get :index
        expect(response.content_type).to eq("text/html")
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end

    describe "GET #new" do
      it "should create a new user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "Put #edit" do
      it "located the requested @user" do
        put :edit,params:{id: @user.id}
        expect(assigns(:user)).to eq(@user)
      end
      it "renders the #edit view" do
        put :edit,params:{id: @user.id}
        expect(response).to render_template("edit")
      end
    end

    describe "GET #show" do
      it "assigns the requested category to @user" do
        get :show, params:{id: @user.id}
        expect(assigns(:user)).to eq(@user)
      end
      it "renders the #show view" do
        get :show, params:{id: @user.id}
        expect(response).to redirect_to(edit_admin_user_path(@user))
      end
    end

    describe "POST #create" do
      it "should create a user" do
        post :create,params:{user: {email:Faker::Internet.email,password: "description",role:"admin"}}
        expect(response).to render_template("edit")
        expect(flash[:success]).to match "User has been successfully created"
      end
    end

    describe "PUT #update" do
      it "should update a user" do
        put :update,params:{id:@user.id,user: {email:Faker::Internet.email,password: "password",role:"admin"}}
        expect(flash[:success]).to eq("translation missing: en.account_updated")
        expect(response).to render_template("edit")
      end
    end
  end
end
