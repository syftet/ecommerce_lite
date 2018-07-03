class FeedbacksController < ApplicationController
  def new

  end

  def create
    feedback = Feedback.new(feedback_params)
    @status = feedback.save
    respond_to do |format|
      format.js
      format.html {
        flash[:success] = 'Thanks! for your kind feedback.'
        redirect_to root_path
      }
    end
  end


  private
  def feedback_params
    params.require(:feedback).permit(:name, :email, :type, :message, :delivery_report, :product_price, :others, :rate)
  end

end


