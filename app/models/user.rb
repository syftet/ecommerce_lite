class User < ApplicationRecord
  ROLES = %w[admin moderator].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  User::ROLES.each do |role|
    define_method("#{role}?") do
      self.role == role
    end
  end
end
