class StockLocation < ApplicationRecord
  has_many :stock_items, dependent: :destroy
  has_many :stock_movements, through: :stock_items

  validates :name, presence: true

  scope :active, -> { where(active: true) }

  after_create :create_stock_items, if: :propagate_all_variants?
  after_save :ensure_one_default

  def propagate_product(product)
    stock_items.create!(product: product, backorderable: backorderable_default)
  end

  def set_up_stock_item(product)
    stock_item(product) || propagate_product(product)
  end

  def stock_item(product_id)
    stock_items.where(product_id: product_id).first
  end

  def stock_item_or_create(product)
    stock_item(product) || stock_items.create(product_id: product.id)
  end

  def count_on_hand(product)
    stock_item(product).try(:count_on_hand)
  end

  def backorderable?(product)
    stock_item(product).try(:backorderable?)
  end

  def restock(product, quantity, originator = nil)
    move(product, quantity, originator)
  end

  def restock_backordered(product, quantity, originator = nil)
    item = stock_item_or_create(product)
    item.update_columns(count_on_hand: item.count_on_hand + quantity, updated_at: Time.current)
  end

  def unstock(product, quantity, originator = nil)
    move(product, -quantity, originator)
  end

  def move(product, quantity, originator = nil)
    stock_item_or_create(product).stock_movements.create!(quantity: quantity, originator: originator)
  end

  def fill_status(product, quantity)
    if item = stock_item(product)

      if item.count_on_hand >= quantity
        on_hand = quantity
        backordered = 0
      else
        on_hand = item.count_on_hand
        on_hand = 0 if on_hand < 0
        backordered = item.backorderable? ? (quantity - on_hand) : 0
      end

      [on_hand, backordered]
    else
      [0, 0]
    end
  end

  private

  def create_stock_items
    Product.all.find_each do |product|
      propagate_product(product)
    end
  end

  def ensure_one_default
    if default
      StockLocation.where(default: true).where.not(id: id).update_all(default: false)
    end
  end
end