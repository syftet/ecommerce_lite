class UsersController < ApplicationController
  before_action :authenticate_user!
  layout 'product'

  def my_account
    @orders = current_user.orders
  end
end