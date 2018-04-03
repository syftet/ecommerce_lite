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
