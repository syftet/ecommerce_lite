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

require 'rails_helper'

RSpec.describe ReturnItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
