# == Schema Information
#
# Table name: shipments
#
#  id                 :integer          not null, primary key
#  tracking           :string(255)
#  number             :string(255)
#  cost               :decimal(10, )    default(0)
#  shipped_at         :datetime
#  order_id           :integer
#  address_id         :integer
#  state              :string(255)
#  stock_location_id  :integer
#  adjustment_total   :decimal(10, )    default(0)
#  promo_total        :decimal(10, )    default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  shipping_method_id :integer
#

class Shipment < ApplicationRecord
  extend FriendlyId
  friendly_id :number, slug_column: :number, use: :slugged

  belongs_to :address, class_name: 'Address'
  belongs_to :order, class_name: 'Order', touch: true
  belongs_to :stock_location, class_name: 'StockLocation'
  belongs_to :shipping_method

  has_many :inventory_units, inverse_of: :shipment

  has_many :trackings

  # validates :stock_location, presence: true

  attr_accessor :special_instructions

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :inventory_units

  # scope :pending, -> { with_state('pending') }
  # scope :ready, -> { with_state('ready') }
  # scope :shipped, -> { with_state('shipped') }
  # scope :trackable, -> { where("tracking IS NOT NULL AND tracking != ''") }
  # scope :with_state, ->(*s) { where(state: s) }
  # # sort by most recent shipped_at, falling back to created_at. add "id desc" to make specs that involve this scope more deterministic.
  # scope :reverse_chronological, -> { order('coalesce(spree_shipments.shipped_at, spree_shipments.created_at) desc', id: :desc) }

  def with_state(s)
    state == s
  end

  def ready?
    order.completed? && with_state('ready')
  end

  def shipped?
    self.with_state('shipped')
  end

  def add_shipping_method(shipping_method, selected = false)
    shipping_rates.create(shipping_method: shipping_method, selected: selected, cost: cost)
  end

  def after_cancel
    manifest.each { |item| manifest_restock(item) }
  end

  def after_resume
    manifest.each { |item| manifest_unstock(item) }
  end

  def backordered?
    inventory_units.any? { |inventory_unit| inventory_unit.backordered? }
  end

  def currency
    order ? order.currency : Config[:currency]
  end


  private

  def recalculate_adjustments
    Adjustable::AdjustmentsUpdater.update(self)
  end

  def send_shipped_email
    ShipmentMailer.shipped_email(id).deliver_later
  end

  def set_cost_zero_when_nil
    self.cost = 0 unless self.cost
  end

  def update_adjustments
    if cost_changed? && state != 'shipped'
      recalculate_adjustments
    end
  end

end
