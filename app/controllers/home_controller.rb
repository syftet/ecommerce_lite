class HomeController < ApplicationController
  def index
    @featured_products = Product.where('product_id IS NULL').includes(:reviews)
    @new_arrivals = Product.new_arrivals.includes(:reviews)
    @feedbacks = Feedback.order(id: :desc).limit(5)
    @blogs = Blog.all.order(:created_at).limit(3)
    @sliders = HomeSlider.all
  end
end
