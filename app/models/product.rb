# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  code            :string(255)      not null
#  name            :string(255)
#  description     :text(65535)
#  origin          :string(255)
#  slug            :string(255)
#  meta_title      :string(255)
#  meta_desc       :text(65535)
#  keywords        :string(255)
#  brand_id        :integer
#  is_featured     :boolean          default(FALSE), not null
#  is_active       :boolean          default(TRUE), not null
#  deleted_at      :datetime
#  product_id      :integer
#  sale_price      :float(53)        default(0.0), not null
#  cost_price      :float(53)        default(0.0), not null
#  whole_sale      :float(53)        default(0.0), not null
#  color_name      :string(255)
#  color           :string(255)
#  size            :string(255)
#  weight          :string(255)
#  width           :string(255)
#  height          :string(255)
#  depth           :string(255)
#  discountable    :boolean          default(FALSE)
#  is_amount       :boolean          default(FALSE)
#  discount        :float(53)        default(0.0), not null
#  reward_point    :float(53)        default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  track_inventory :boolean          default(TRUE)
#  pos_id          :integer
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#

require 'net/http'

class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  attr_readonly :price

  belongs_to :brand, class_name: 'Admin::Brand'
  belongs_to :product, foreign_key: :product_id
  has_many :product_categories, dependent: :destroy
  has_many :categories, class_name: 'Admin::Category', through: :product_categories
  has_many :variants, class_name: 'Product', foreign_key: :product_id, dependent: :destroy
  has_many :images, as: :viewable, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :related_products, inverse_of: :product
  has_many :stock_items, dependent: :destroy
  has_many :wishlists, dependent: :destroy

  accepts_nested_attributes_for :images,
                                allow_destroy: true,
                                reject_if: proc { |attributes|
                                  attributes.all? { |k, v| v.blank? }
                                }


  validates_presence_of :name, :code, :cost_price, :sale_price, :slug
  validates_uniqueness_of :code

  after_create :create_stock_items

  scope :active, -> { where(is_active: true) }
  scope :master, -> { where(product_id: nil) }
  scope :master_active, -> { where(is_active: true, product_id: nil) }
  scope :in_stock, -> { joins(:stock_items).where('count_on_hand > ? OR track_inventory = ?', 0, false) }
  scope :featured, -> { master_active.where(is_featured: true) }
  scope :new_arrivals, -> { master_active.where('created_at >= ?', 15.days.ago) }

  def slug_candidates
    [:name, :name_and_sequence]
  end

  def name_and_sequence
    slug = name.to_param
    sequence = Product.where("slug like '%#{slug}%'").count
    "#{slug}--#{sequence}"
  end

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

  def on_stock
    return false unless pos_id.present?
    uri = URI("http://accounts.tangailenterprise.com/api/products/#{pos_id}/stock_on_hand")
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.path, 'Content-Type' => 'application/json')
    res = http.request(req)
    if res.body.to_i > 0
      true
    else
      false
    end
  rescue => e
    puts "failed #{e}"
  end

  def self.search_by_name_or_code(query_param)
    where('products.name LIKE :q OR products.code LIKE :q', q: "%#{query_param}%")
  end

  def self.advance_search(params, products)
    params_hash = {}
    if params[:product].present?
      if params[:product][:created_at_gt].present? && params[:product][:created_at_lt].present?
        from_date = params[:product][:created_at_gt].to_date
        to_date = params[:product][:created_at_lt].to_date
        params_hash[:created_at_gt] = params[:product][:created_at_gt]
        params_hash[:created_at_lt] = params[:product][:created_at_lt]
        products = products.where(created_at: from_date.beginning_of_day..to_date.end_of_day)
      elsif params[:product][:created_at_gt].present?
        # from_date = Time.strptime(params[:order][:created_at_gt], '%m/%d/%Y')
        params_hash[:created_at_gt] = params[:product][:created_at_gt]
        products = products.where(created_at: params[:product][:created_at_gt].to_date.beginning_of_day..params[:product][:created_at_gt].to_date)
      elsif params[:product][:created_at_lt].present?
        to_date = params[:product][:created_at_lt].to_date
        params_hash[:created_at_lt] = params[:product][:created_at_lt]
        products = products.where(created_at: to_date.beginning_of_day..to_date.beginning_of_day)
      end

      if params[:product][:pos_id].present?
        params_hash[:pos_id] = params[:product][:pos_id]
        products = products.where(pos_id: params[:product][:pos_id])
      end

      if params[:product][:is_active].present?
        params_hash[:is_active] = params[:product][:is_active]
        products = products.where(is_active: params[:product][:is_active])
      end
    end
    { products: products, params_hash: params_hash }
  end

  def price(user = nil)
    discountable ? discount_price : sale_price
  end

  def self.featured_products
    where(is_featured: true)
  end

  def discount_price
    is_amount ? flat_discount : percentage_discount
  end

  def flat_discount
    sale_price - discount
  end

  def discount_amount
    return 0 unless discountable
    is_amount ? discount : (sale_price * (discount / 100.0))
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

  def total_on_hand
    stock_items.sum(:count_on_hand)
  end

  def variants_total_on_hand
    sum = 0
    variants_with_master.each do |va|
      sum =  sum + va.total_on_hand
    end
    sum
  end

  def average_rating
    total_review = reviews.count
    ratings = reviews.sum(:rating)
    if total_review > 0
      (ratings / total_review)
    else
      0
    end
  end

  def is_favourite?(user_id)
    user_id.present? && wishlists.where(user_id: user_id).present?
  end

  private

  def create_stock_items
    StockLocation.where(propagate_all_variants: true).each do |stock_location|
      stock_location.propagate_product(self)
    end
  end
end
