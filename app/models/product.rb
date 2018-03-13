class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_readonly :price

  belongs_to :brand, class_name: 'Admin::Brand'
  belongs_to :product, foreign_key: :product_id
  has_many :product_categories, dependent: :destroy
  has_many :categories, class_name: 'Admin::Category', through: :product_categories
  has_many :variants, class_name: 'Product', foreign_key: :product_id, dependent: :destroy
  has_many :images, as: :viewable, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :related_products, inverse_of: :product
  has_many :stock_items

  accepts_nested_attributes_for :images,
                                allow_destroy: true,
                                reject_if: proc { |attributes|
                                  attributes.all? { |k, v| v.blank? }
                                }

  validates_presence_of :name, :code, :cost_price, :sale_price, :is_active, :slug
  validates_uniqueness_of :code

  scope :active, -> { where(is_active: true) }
  scope :master, -> { where(product_id: nil) }
  scope :master_active, -> { where(is_active: true, product_id: nil) }
  scope :in_stock, -> { joins(:stock_items).where('count_on_hand > ? OR track_inventory = ?', 0, false) }

  def master?
    !product.present?
  end

  def variant?
    product.present?
  end

  def variants_with_master
    [self, variants].flatten!
  end

  def self.generate_code
    "P00#{Product.last.present? ? (Product.last.id + 1) : 1}"
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

  def should_track_inventory?
    track_inventory? #&& Config.track_inventory_levels TODO: Need to check this
  end

  def track_inventory
    should_track_inventory?
  end

  def volume
    (width || 0) * (height || 0) * (depth || 0)
  end

  def dimension
    (width || 0) + (height || 0) + (depth || 0)
  end

  def total_on_hand
    2 #TODO: Calculate stock
  end

  def on_stock
    true
  end

end
