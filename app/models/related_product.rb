class RelatedProduct < ApplicationRecord
  belongs_to :product
  belongs_to :relative_product, foreign_key: :relative_id, class_name: 'Product'
end
