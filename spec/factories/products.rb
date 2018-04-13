# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  code            :string(255)      not null
#  name            :string(255)
#  description     :text(65535)
#  origin          :string(255)
#  slug            :string(255)
#  meta_title      :string(255)
#  meta_desc       :text(65535)
#  keywords        :string(255)
#  brand_id        :integer
#  is_featured     :boolean          default(FALSE), not null
#  is_active       :boolean          default(TRUE), not null
#  deleted_at      :datetime
#  product_id      :integer
#  sale_price      :float(53)        default(0.0), not null
#  cost_price      :float(53)        default(0.0), not null
#  whole_sale      :float(53)        default(0.0), not null
#  color_name      :string(255)
#  color           :string(255)
#  size            :string(255)
#  weight          :string(255)
#  width           :string(255)
#  height          :string(255)
#  depth           :string(255)
#  discountable    :boolean          default(FALSE)
#  is_amount       :boolean          default(FALSE)
#  discount        :float(53)        default(0.0), not null
#  reward_point    :float(53)        default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  track_inventory :boolean          default(TRUE)
#
# Indexes
#
#  index_products_on_brand_id  (brand_id)
#

FactoryBot.define do
  factory :product do
    name 'Joeee'
    description 'This is description'
    code Product.generate_code
    slug 'sluggg'
  end

end
