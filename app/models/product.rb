class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_readonly :price

  belongs_to :brand, class_name: 'Admin::Brand'
  has_many :product_categories
  has_many :categories, class_name: 'Admin::Category', through: :product_categories

  scope :active, -> { where(is_active: true) }

  def price
    discountable ? discount_price : sale_price
  end

  def discount_price
    is_amount ? flat_discount : percentage_discount
  end

  def flat_discount
    sale_price - discount
  end

  def percentage_discount
    sale_price - (sale_price * (discount / 100.0))
  end
end
