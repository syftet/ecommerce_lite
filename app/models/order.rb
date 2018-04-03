# == Schema Information
#
# Table name: orders
#
#  id                     :integer          not null, primary key
#  number                 :string(255)
#  item_total             :decimal(10, )    default(0)
#  total                  :decimal(10, )    default(0)
#  state                  :string(255)
#  adjustment_total       :decimal(10, )    default(0)
#  user_id                :integer
#  completed_at           :datetime
#  ship_address_id        :integer
#  payment_total          :decimal(10, )    default(0)
#  shipment_state         :string(255)
#  payment_state          :string(255)
#  email                  :string(255)
#  currency               :string(255)
#  created_by_id          :string(255)
#  shipment_total         :decimal(10, )    default(0)
#  promo_total            :decimal(10, )    default(0)
#  item_count             :integer
#  approver_id            :integer
#  approved_at            :datetime
#  confirmation_delivered :boolean
#  guest_token            :string(255)
#  canceled_at            :datetime
#  canceler_id            :integer
#  store_id               :integer
#  shipment_date          :date
#  shipment_progress      :integer          default(0)
#  shipped_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  special_instructions   :text(65535)
#  collection_point       :string(255)
#

# require 'order/checkout'
class Order < ApplicationRecord
  PAYMENT_STATES = %w(balance_due credit_owed failed paid void)
  SHIPMENT_STATES = %w(backorder canceled partial processing pending ready shipped delivered canceled refunded )
  ORDER_SHIPMENT_STATE = {
      processing: 'Processing',
      payment_failed: 'Payment failed',
      pending: 'Preparing your order',
      ready: 'Ready to ship',
      shipped: 'Shipped'
  }

  ORDER_STATES = %w(address delivery payment completed approved canceled)

  ORDER_ALL_SHIPMENT_STATE = {
      processing: 'Processing',
      payment_failed: 'Payment failed',
      pending: 'Preparing your order',
      ready: 'Ready to ship',
      shipped: 'Shipped',
      delivered: 'Delivered',
      canceled: 'Canceled',
      refunded: 'Refunded'
  }

  ORDER_SMTP = {
      address: 'smtp.zoho.com',
      port: 465,
      domain: 'lienesbeauty.com',
      user_name: 'sales@lienesbeauty.com',
      password: 'Shop2017',
      authentication: :plain,
      ssl: true,
      enable_starttls_auto: true
  }

  extend FriendlyId
  include GenerateNumber

  friendly_id :number, slug_column: :number, use: :slugged

  has_many :line_items
  belongs_to :ship_address, foreign_key: :ship_address_id, class_name: 'Address'
  has_one :shipment
  belongs_to :user

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :ship_address
  # accepts_nested_attributes_for :payments
  # accepts_nested_attributes_for :shipments

  attr_accessor :shipping_method, :prefix

  def can_approve?
    completed? && self.state != 'approved'
  end

  def can_cancel?
    self.state == 'approved'
  end

  def can_resume?
    self.state == 'canceled'
  end

  def you_saved
    line_items.collect { |item| item.product.discount_amount }.sum
  end

  def net_total
    if shipment.present?
      (self.total || 0) + (shipment.cost || 0)
    else
      self.total
    end
  end

  def adjustment_total
    0
  end

  def next
    if self.state == 'address'
      self.state = 'delivery'
    elsif self.state == 'delivery'
      self.state = 'payment'
    end
    self.save
  end

  def contents
    @contents ||= OrderContents.new(self)
  end

  def update_with_params(params, permitted_params)

    if params[:state] == 'address'
      self.update_attributes(permitted_params)
    elsif params[:state] == 'delivery'
      if init_shipment(permitted_params.delete(:shipping_method))
        self.update_attributes(permitted_params)
      else
        false
     end
    end
  end

  def completed?
    !self.completed_at.blank?
  end

  def self.get_incomplete_order(token, user)
    order = self.where("guest_token = ? and completed_at IS NULL", token).last
    if user.present? && !order.present?
      order = user.orders.where('completed_at IS NULL').last
    end
    order
  end

  def collect_rewards_point
    if self.user.present? && self.approved_at.present?
      reward_point = self.user.rewards_points.find_or_initialize_by(order_id: self.id, user_id: self.user_id, reason: 'Checkout')
      reward_point.points = self.line_items.sum(&:credit_point)
      reward_point.save
    end
  end

  def init_shipment(shipping_method)
    shipping = ShippingMethod.find_by_id(shipping_method)
    u_shipment = self.shipment || self.build_shipment
    u_shipment.cost = shipping.rate
    u_shipment.address_id = self.ship_address.id
    u_shipment.tracking = shipping.code
    u_shipment.shipping_method_id = shipping.id
    u_shipment.state = 'pending'
    u_shipment.save!
  end

end
