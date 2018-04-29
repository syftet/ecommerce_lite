class Api::V1::UsersController < Api::ApiBase
  before_action :load_user

  def my_account
    render json: {success: true, account_data: account_data}
  end

  private

  def account_data
    data = {
        user: {email: @user.email, total_rewards: @user.total_rewards, available_rewards: @user.available_rewards},
        rewards_points: @user.rewards_points,
        orders: @user.orders.collect { |order| {number: order.number, id: order.id, status: order.state, amount: order.amount, date: order.created_at} }
    }
  end
end