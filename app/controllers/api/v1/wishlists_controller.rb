class Api::V1::WishlistsController < Api::ApiBase
  before_action :load_user

  def index
    wishlists = @user.wishlists.page(params[:page])

    response = {
        total_item: wishlists.total_count,
        success: true,
        products: []
    }

    wishlists.each do |wishlist|
      product = wishlist.product
      if product.present?
        response[:products] << {
            id: product.id,
            wish_id: wishlist.id,
            name: product.name,
            avg_rating: product.average_rating,
            preview_image: helpers.product_preview_image(product, true),
            price: product.price,
            discount_price: product.discount_price,
            is_favourited: true,
            # promotion: product.promotionable,
            total_on_hand: product.total_on_hand,
            categories: product.categories.as_json(only: [:id, :name])
        }
      end
    end

    render json: response
  end

  def create
    wishlist = @user.wishlists.find_or_initialize_by(product_id: params[:product_id])
    status = wishlist.new_record? ? wishlist.save : (wishlist.destroy ? true : false)
    render json: {status: status}
  end

  def remove
    wishlist = @user.wishlists.find_by_id(params[:wishlist_id])
    if wishlist
      status = wishlist.destroy ? true : false
      message = status ? 'Wishlist removed' : 'Unable to remove from wishlist'
    else
      status = false
      message = 'Wishlist not found'
    end
    render json: {success: status, message: message}
  end

end
