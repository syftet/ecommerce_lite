require 'rails_helper'

RSpec.describe Admin::BlogsController, type: :controller do
  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
    end
    describe "GET #index" do
      it "assigns @blogs" do
        blog = create(:blog)
        get :index
        expect(assigns(:blogs)).to eq([blog])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end
    describe "GET #show" do
      it "assigns the requested blog to @blog" do
        blog = create(:blog)
        get :show, params:{id: blog.id}
        expect(assigns(:blog)).to eq(blog)
      end
      it "renders the #show view" do
        blog = create(:blog)
        get :show, params:{id: blog.id}
        expect(response).to render_template("show")
      end
    end
    describe "GET #new" do
      it "should create a new blog" do
        get :new
        expect(assigns(:blog)).to be_a_new(Blog)
      end
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end
    describe "Put #edit" do
      it "located the requested @blog" do
        blog = create(:blog)
        put :edit,params:{id: blog.id}
        expect(assigns(:blog)).to eq(blog)
      end
      it "renders the #edit view" do
        blog = create(:blog)
        put :edit,params:{id: blog.id}
        expect(response).to render_template("edit")
      end
    end
    describe "POST #create" do
      it "should create a blog" do
        post :create,params:{blog: { title: " title",body:"this", cover_photo:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
        expect(response).to redirect_to(admin_blogs_path)
      end
      it "should render new" do
        post :create,params:{blog: { title: " title", cover_photo:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
        expect(response).to render_template("new")
      end
    end
    describe "PUT #update" do
      it "should update a blog" do
        blog = create(:blog)
        put :update,params:{id: blog.id,blog: { title: " title",body:"this", cover_photo:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
        expect(response).to redirect_to(admin_blogs_path)
      end
    end
    describe "Delete #destroy" do
      it "should remove the blog" do
        blog = create(:blog)
        delete :destroy,params:{id: blog.id}
        expect(response).to redirect_to(blogs_url)
      end
    end
  end
  context "if user is not admin" do
    it "should redirect to bas url" do
      get :index
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to bas url" do
      blog = create(:blog)
      get :show, params:{id: blog.id}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to bas url" do
      get :new
      expect(response).to redirect_to(root_url)
    end

    it "should redirect to bas url" do
      blog = create(:blog)
      delete :destroy,params:{id: blog.id}
      expect(response).to redirect_to(root_url)
    end
  end
end


