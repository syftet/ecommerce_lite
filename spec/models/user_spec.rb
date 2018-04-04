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
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do

  describe "admin?" do
    before(:each) do
      @user = User.create(role:"admin",email:"ahad@gmail.com",password:"12334sdf43")

    end
    it 'should return true' do
      expect(@user.admin?).to eq(true)
    end
    it 'should return false' do
      expect(@user.moderator?).to eq(false)
    end
  end

  describe "moderator?" do
    before(:each) do
      @user = User.create(role:"moderator",email:"ahaad@gmail.com",password:"1334sdf43")

    end
    it 'should return true' do
      expect(@user.moderator?).to eq(true)
    end
    it 'should return false' do
      expect(@user.admin?).to eq(false)
    end
  end

  describe ".available_rewards" do
    before(:each) do
     # rewardPoint = RewardsPoint.create(points:10.0)
      @user = User.create(role:"moderator",email:"ahaad@gmail.com",password:"1334sdf43")
      @user.rewards_points.create(points:10.0)
    end
    it 'should return total reward point' do
      expect(@user.available_rewards).to eq(10.0)
    end
  end

  describe ".total_rewards" do
    it 'should return sum of reward point ' do
      user = User.create(role:"moderator",email:"ahaad@gmail.com",password:"1334sdf43")
      user.rewards_points.create(points:10.0)
      expect(user.total_rewards).to eq(10.0)
    end

    it 'should return 0 ' do
      user = User.create(role:"moderator",email:"ahaad@gmail.com",password:"1334sdf43")
      user.rewards_points.create(points:0.0)
      expect(user.total_rewards).to eq(0)
    end
  end

end
