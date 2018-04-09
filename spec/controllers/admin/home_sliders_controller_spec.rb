require 'rails_helper'

RSpec.describe Admin::HomeSlidersController, type: :controller do
  context "if user is admin" do
    before(:each) do
      @user = create(:user)
      sign_in(@user)
    end

    describe "GET #index" do
      it "assigns @homeSlider" do
        homeSlider = create(:homeSlider)
        get :index
        expect(assigns(:sliders)).to eq([homeSlider])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
        end
    end
    describe "GET #new" do
      it "should create a new slider" do
        get :new
        expect(assigns(:slider)).to be_a_new(HomeSlider)
      end
      it "renders the #new view" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "POST #create" do
      it "should create a slider" do
        post :create,params:{home_slider: { title: "this call title",sub_title:"this called subtitle", image:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
        expect(response).to redirect_to(admin_home_sliders_path)
      end
    end

    describe "Put #edit" do
      it "located the requested @slider" do
        homeSlider = create(:homeSlider)
        put :edit,params:{id: homeSlider.id}
        expect(assigns(:slider)).to eq(homeSlider)
      end
      it "renders the #edit view" do
        homeSlider = create(:homeSlider)
        put :edit,params:{id: homeSlider.id}
        expect(response).to render_template("edit")
      end
    end

    describe "PUT #update" do
      it "should update a slider" do
        homeSlider = create(:homeSlider)
        put :update,params:{id: homeSlider.id,home_slider: { title: "title1",sub_title:"subtitle1", image:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
        expect(response).to redirect_to(admin_home_sliders_path)
      end
    end
    describe "Delete #destroy" do
      it "should remove the slider" do
        homeSlider = create(:homeSlider)
        delete :destroy,format: :js,params:{id: homeSlider.id}
        expect(response.content_type).to eq("text/javascript")
      end
    end

  end

  context "if user is not admin" do
    it "should redirect to base url" do
      get :index
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      get :new
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      post :create,params:{home_slider: { title: "this call title",sub_title:"this called subtitle", image:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      homeSlider = create(:homeSlider)
      put :edit,params:{id: homeSlider.id}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      homeSlider = create(:homeSlider)
      put :update,params:{id: homeSlider.id,home_slider: { title: "title1",sub_title:"subtitle1", image:Rack::Test::UploadedFile.new(Rails.root.join('spec','support','images', 'logo.png'), 'image/png')}}
      expect(response).to redirect_to(root_url)
    end
    it "should redirect to base url" do
      homeSlider = create(:homeSlider)
      delete :destroy,format: :js,params:{id: homeSlider.id}
      expect(response).to redirect_to(root_url)
    end
  end
end
