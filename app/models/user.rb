# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)
#  name                   :string(255)
#  ship_address_id        :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  ROLES = %w(admin moderator).freeze
  include UserReporting

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :wishlists
  has_many :reviews
  has_many :orders
  has_many :rewards_points
  belongs_to :ship_address, class_name: 'Address'

  accepts_nested_attributes_for :ship_address


  ROLES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end

  def total_rewards
    rewards_points.collect { |rp| rp.points > 0 ? rp.points : 0 }.sum
  end

  def available_rewards
    rewards_points.sum(:points)
  end

  def purchased
    orders.where("approved_at IS NOT NULL").sum(:total)
  end

end
