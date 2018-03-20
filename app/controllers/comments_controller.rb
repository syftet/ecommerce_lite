class CommentsController < ApplicationController

  def create
    blog = Blog.friendly.find(params[:blog_id])
    comment = blog.comments.new(comment_params)
    comment.user = current_user
    comment.save
    redirect_to blog_path(blog)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:body)
  end
end
