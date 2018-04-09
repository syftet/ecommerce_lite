require 'rails_helper'

RSpec.describe Admin::CommentsController, type: :controller do
  context "if user is admin" do
    before(:each) do
      @blog = create(:blog)
      @user = create(:user)
      sign_in(@user)
      @comment = Comment.create(body:"Body",user_id:@user.id,blog_id:@blog.id,is_approved:true)
    end
    describe "PUT #update" do
      it "should update a comment" do
        put :update,params:{id: @comment.id,blog_id:@blog.id,comment: {body:"this is Body",user_id:@user.id,blog_id:@blog.id,is_approved:true}}
        expect(response).to redirect_to(admin_blog_path(@blog))
        end
    end
    describe "Delete #destroy" do
      it "should remove the comment" do
        delete :destroy,params:{id: @comment.id,blog_id:@blog.id}
        expect(response).to redirect_to(admin_blog_url(@blog))
      end
    end
  end

  context "if user is not admin" do
    before(:each) do
      @blog = create(:blog)
      @user = create(:user)
      @comment = Comment.create(body:"Body",user_id:@user.id,blog_id:@blog.id,is_approved:true)
    end
    it "should redirect to base url" do
      put :update,params:{id: @comment.id,blog_id:@blog.id,comment: {body:"this is Body",user_id:@user.id,blog_id:@blog.id,is_approved:true}}
      expect(response).to redirect_to(root_url)
      end
    it "should redirect to base url" do
      delete :destroy,params:{id: @comment.id,blog_id:@blog.id}
      expect(response).to redirect_to(root_url)
    end
  end

end
