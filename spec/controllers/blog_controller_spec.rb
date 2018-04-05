require 'rails_helper'

RSpec.describe BlogsController, type: :controller do

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

end
