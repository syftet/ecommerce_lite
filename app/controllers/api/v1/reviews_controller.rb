class Api::V1::ReviewsController < Api::ApiBase
  before_action :load_user, only: [:create, :update, :destroy]

  def index
    product = Product.includes(:reviews).find_by_id(params[:product_id])
    reviews = product.reviews.order(created_at: :desc) # .page(params[:page]).per(Syftet.config.product_per_page_mobile_api)

    render json: {
               avg_rating: product.average_rating,
               total_review: reviews.count,
               rating_detail: product.reviews.group(:rating).count,
               reviews: reviews
           }
  end

  def create
    review = current_user.reviews.build(name: params[:name], rating: params[:rating], text: params[:text], product_id: params[:product_id], email: current_user.email)
    status = review.save
    render json: {status: status, response: status ? 'Thank you for your review' : review.errors.first}
  end

  def update
    review = Review.find_by_id(params[:id])
    status = review.update_attributes(name: params[:name], rating: params[:rating], text: params[:text], product_id: params[:product_id], user_id: current_user.id, email: current_user.email)

    render json: {status: status}
  end

  def destroy
    review = Review.find_by_id(params[:id])
    status = review.destroy ? true : false

    render json: {status: status}
  end
end
