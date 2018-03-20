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
