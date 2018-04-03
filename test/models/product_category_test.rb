# == Schema Information
#
# Table name: product_categories
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_product_categories_on_category_id  (category_id)
#  index_product_categories_on_product_id   (product_id)
#

require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
