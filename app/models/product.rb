class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_readonly :price

  belongs_to :brand, class_name: 'Admin::Brand'
  belongs_to :product, foreign_key: :product_id
  has_many :product_categories, dependent: :destroy
  has_many :categories, class_name: 'Admin::Category', through: :product_categories
  has_many :variants, class_name: 'Product', foreign_key: :product_id, dependent: :destroy

  validates_presence_of :name, :code, :cost_price, :sale_price, :is_active, :slug
  validates_uniqueness_of :code

  scope :active, -> { where(is_active: true, product_id: nil) }

  def product?
    !product.present?
  end

  def variant?
    product.present?
  end

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
