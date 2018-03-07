class ProductCategory < ApplicationRecord
  belongs_to :product
  belongs_to :category, class_name: 'Admin::Category'
end
