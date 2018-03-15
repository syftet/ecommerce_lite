class CategoriesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found
  # helper 'products'
  layout 'product'
  respond_to :html

  def show
    @category = Admin::Category.find_by_permalink(params[:id])
    @categories = Admin::Category.where("parent_id IS NULL")
    @top_category = @category.category
    redirect_to products_path unless @category
    @products = Search.new(params, @category).result
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  private

  def accurate_title
    @taxon.try(:seo_title) || super
  end
end