# == Schema Information
#
# Table name: stock_movements
#
#  id              :integer          not null, primary key
#  stock_item_id   :integer
#  quantity        :integer          default(0)
#  action          :string(255)
#  originator_id   :integer
#  originator_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class StockMovement < ApplicationRecord
  belongs_to :stock_item
  belongs_to :originator, polymorphic: true

  after_create :update_stock_item_quantity

  with_options presence: true do
    validates :stock_item
    validates :quantity, numericality: {
        greater_than_or_equal_to: -2**31,
        less_than_or_equal_to: 2**31 - 1,
        only_integer: true,
        allow_nil: true
    }
  end

  scope :recent, -> { order(created_at: :desc) }

  def readonly?
    !new_record?
  end

  private

  def update_stock_item_quantity
    # return unless self.stock_item.should_track_inventory? # TODO: Check later
    stock_item.adjust_count_on_hand quantity
  end
end
