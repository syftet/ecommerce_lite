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
  friendly_id :number, slug_column: :number, use: :slugged

  has_many :line_items

  def contents
    @contents ||= OrderContents.new(self)
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
end