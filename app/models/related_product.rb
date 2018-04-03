# == Schema Information
#
# Table name: related_products
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  relative_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RelatedProduct < ApplicationRecord
  belongs_to :product
  belongs_to :relative_product, foreign_key: :relative_id, class_name: 'Product'
end
