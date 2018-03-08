module Admin
  class CommentsController < Admin::BaseController
    before_action :set_comment, only: [:edit, :update, :destroy]

    def edit
    end

    def update
      blog = Blog.friendly.find(params[:blog_id])
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to admin_blog_path(blog), notice: 'Comment was successfully updated.' }
        else
          format.html { render :edit }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      blog = Blog.friendly.find(params[:blog_id])
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to admin_blog_url(blog), notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body, :user_id, :is_approved, :blog_id)
    end
  end
end