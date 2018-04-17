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
  PREFIX = 'OR-'
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
  has_many :payments

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :ship_address
  accepts_nested_attributes_for :payments
  # accepts_nested_attributes_for :shipments

  attr_accessor :shipping_method

  def prefix
    Order::PREFIX
  end

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
        self.update_attributes(permitted_params.merge({shipment_state: 'pending'}))
      end
    elsif params[:state] == 'payment'
      payment = build_payment(permitted_params)
      unless payment.errors.any?
        self.completed_at = Time.now
        self.state = 'completed'
        self.shipment_state = Order::ORDER_SHIPMENT_STATE[:pending]
        self.payment_state = payment.state == 'completed' ? 'completed' : 'balance_due'
        if self.save
          deliver_order_confirmation_email unless confirmation_delivered?
        end
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

  def deliver_order_confirmation_email
    OrderMailer.confirm_email(id).deliver_now # TODO: will send email after getting smtp credential
    update_column(:confirmation_delivered, true)
    update_column(:shipment_state, nil)
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

  def build_payment(payments_attributes)
    payment_method_id = payments_attributes[:payments_attributes][:payment_method_id]
    payment_method = PaymentMethod.find_by_id(payment_method_id)
    return false unless payment_method.present?
    payment_params = payment_method.process
    payment_params[:amount] = self.net_total
    payment_params[:payment_method_id] = payment_method_id
    payment = self.payments.build(payment_params)
    payment.save
    payment
  end

  def approved_by(user)
    self.update_attributes({approver_id: user.id, approved_at: Time.current})
  end

  def credit_rewards_point
    points = line_items.collect { |item| item.product.reward_point }.sum
    if points > 0
      reward_point = RewardsPoint.where(order_id: self.id, user_id: self.user_id).first
      if reward_point.present?
        reward_point.points = points
        reward_point.save
      else
        RewardsPoint.create(order_id: self.id, user_id: self.user_id, points: points, reason: 'Order Checkout Credit Points')
      end
    end
  end

end
