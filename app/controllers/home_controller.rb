class HomeController < ApplicationController
  def index
    @featured_products = Product.featured_products.includes(:reviews).order(id: :desc).limit(5)
    @new_arrivals = Product.new_arrivals.includes(:reviews)
    @feedbacks = Feedback.order(id: :desc).limit(5)
    @blogs = Blog.all.order(:created_at).limit(3)
    @sliders = HomeSlider.all
  end
end