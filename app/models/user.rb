class User < ApplicationRecord
  ROLES = %w(admin moderator).freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :wishlists
  has_many :reviews
  has_many :orders

  ROLES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end
end
