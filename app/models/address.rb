# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  firstname  :string(255)
#  lastname   :string(255)
#  address    :string(255)
#  city       :string(255)
#  zipcode    :string(255)
#  phone      :string(255)
#  state      :string(255)
#  company    :string(255)
#  country    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Address < ApplicationRecord

  with_options presence: true do
    validates :firstname, :lastname, :address, :city, :country
    validates :zipcode
    validates :phone
  end

  alias_attribute :first_name, :firstname
  alias_attribute :last_name, :lastname

  def self.build_default(user)
    if user.present? && user.ship_address.present?
      user.ship_address.clone
    else
      new
    end
  end

  def full_name
    "#{firstname} #{lastname}".strip
  end

  def to_s
    "#{full_name}: #{address}"
  end

  def clone
    self.class.new(self.attributes.except('id', 'updated_at', 'created_at'))
  end
end
