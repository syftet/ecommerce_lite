require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "POST create" do
    before(:each) do
      @blog = create(:blog)
      @user = create(:user)
      sign_in(@user)
    end

    context "if comment save" do
      it "should request to create" do
        post :create, params:{blog_id: @blog.id,comment:{body:"weeeeeeeeeeeeeeerwerwerwerwerr"}}
        expect(response).to redirect_to(blog_path(@blog))
      end

      it 'should incremet by 1' do
        count = @blog.comments.count
        post :create,params:{blog_id: @blog.id,comment:{body:"weeeeeeeeeeeeeeerwerwerwerwerr"}}
        expect(@blog.comments.count).to eq(count+1)
      end
    end
  end

end
