class Address < ApplicationRecord

  with_options presence: true do
    validates :firstname, :lastname, :address, :city, :country
    validates :zipcode
    validates :phone
  end

  alias_attribute :first_name, :firstname
  alias_attribute :last_name, :lastname

  def self.build_default
    new
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