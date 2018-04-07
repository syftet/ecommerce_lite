class WishlistsController < ApplicationController
  before_action :custom_authenticate_user!
  layout 'product'

  def create
      @product = Product.find_by_id(params[:product_id])
      wishlist = current_user.wishlists.find_or_initialize_by(product_id: @product.id)
      @status = wishlist.save
      respond_to do |format|
        format.js
      end
  end


  def destroy
    wishlist = current_user.wishlists.find_by_id(params[:id])
    wishlist.destroy
    respond_to do |format|
      format.js
    end
  end

  def index
    @wishlists = current_user.wishlists
  end
end