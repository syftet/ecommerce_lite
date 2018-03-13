class Address < ApplicationRecord

  with_options presence: true do
    validates :firstname, :lastname, :address, :city, :country
    validates :zipcode
    validates :phone
  end

  alias_attribute :first_name, :firstname
  alias_attribute :last_name, :lastname

  # Can modify an address if it's not been used in an order (but checkouts controller has finer control)
  # def editable?
  #   new_record? || (shipments.empty? && checkouts.empty?)
  # end

  def self.build_default
    new
  end

  def full_name
    "#{firstname} #{lastname}".strip
  end

  def state_text
    state.try(:abbr) || state.try(:name) || state_name
  end

  def to_s
    "#{full_name}: #{address}"
  end

  def clone
    self.class.new(self.attributes.except('id', 'updated_at', 'created_at'))
  end
end