class HomeController < ApplicationController
  def index
    #current_user.update_attribute(:role, 'admin')
    @featured_products = Product.all
    @new_arrivals = [] #Product.new_arrivals
    @feedbacks = [] #Feedback.order(id: :desc).limit(5)
    @blogs = Blog.all.order(:created_at).limit(3)
    @sliders = HomeSlider.all
  end
end
