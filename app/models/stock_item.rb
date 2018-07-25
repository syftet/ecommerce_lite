# == Schema Information
#
# Table name: stock_items
#
#  id                :integer          not null, primary key
#  stock_location_id :integer
#  product_id        :integer
#  count_on_hand     :integer          default(0)
#  backorderable     :boolean          default(FALSE)
#  deleted_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class StockItem < ApplicationRecord
  belongs_to :stock_location
  belongs_to :product
  has_many :stock_movements, dependent: :nullify

  validates :stock_location, :product, presence: true

  validates :product_id, uniqueness: {scope: [:stock_location_id, :deleted_at]}, allow_blank: true

  validates :count_on_hand, numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 2**31 - 1,
      only_integer: true
  }, if: :verify_count_on_hand?

  delegate :weight, to: :product
  delegate :name, to: :product, prefix: true

  after_save :conditional_product_touch, if: :saved_changes?
  after_touch { product.touch }
  after_destroy { product.touch }

  scope :with_active_stock_location, -> { joins(:stock_location).merge(StockLocation.active) }

  # def backordered_inventory_units # TODO: Check later
  #   InventoryUnit.backordered_for_stock_item(self)
  # end

  def self.search_by_name_or_code(query_param)
    joins(:product).where('products.name LIKE :q OR products.code LIKE :q OR products.id LIKE :q', q: "%#{query_param}%")
  end

  def adjust_count_on_hand(value)
    with_lock do
      set_count_on_hand((count_on_hand || 0) + value)
    end
  end

  def set_count_on_hand(value)
    self.count_on_hand = value
    # process_backorders(count_on_hand - (count_on_hand_before_last_save || 0)) # TODO: Check later
    save!
  end

  def in_stock?
    count_on_hand > 0
  end

  def available?
    in_stock? || backorderable?
  end

  def reduce_count_on_hand_to_zero
    set_count_on_hand(0) if count_on_hand > 0
  end

  private

  def verify_count_on_hand?
    saved_change_to_count_on_hand? && !backorderable? && (count_on_hand < count_on_hand_before_last_save) && (count_on_hand < 0)
  end

  # Process backorders based on amount of stock received
  # If stock was -20 and is now -15 (increase of 5 units), then we should process 5 inventory orders.
  # If stock was -20 but then was -25 (decrease of 5 units), do nothing.
  # def process_backorders(number)
  #   if number > 0
  #     backordered_inventory_units.first(number).each(&:fill_backorder)
  #   end
  # end

  def conditional_product_touch
    stock_changed = (saved_change_to_count_on_hand? && saved_change_to_count_on_hand.any?(&:zero?)) || saved_change_to_product_id?
    product.touch if stock_changed
  end
end
