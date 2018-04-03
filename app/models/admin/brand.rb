# == Schema Information
#
# Table name: admin_brands
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  description :text(65535)
#  permalink   :string(255)
#  meta_title  :string(255)
#  meta_desc   :string(255)
#  keywords    :string(255)
#  is_active   :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Admin::Brand < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :products, dependent: :destroy

  after_save :set_permalink
  before_destroy :check_product

  self.table_name = 'admin_brands'

  private

  def set_permalink
    update_column(:permalink, slug)
  end

  def check_product
    !products.present?
  end
end
