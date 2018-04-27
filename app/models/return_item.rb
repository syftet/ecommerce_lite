# == Schema Information
#
# Table name: return_items
#
#  id                 :integer          not null, primary key
#  customer_return_id :integer
#  line_item_id       :integer
#  resellable         :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class ReturnItem < ApplicationRecord
  belongs_to :customer_return
  belongs_to :line_item

  attr_accessor :returned
end
