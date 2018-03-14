class User < ApplicationRecord
  ROLES = %w(admin moderator).freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :wishlists
  has_many :reviews
  has_many :orders
  has_many :rewards_points

  ROLES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end

  def available_rewards
    rewards_points.sum(:points)
  end
end
