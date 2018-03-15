class Admin::Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  self.table_name = 'admin_categories'

  after_save :set_permalink

  has_many :sub_categories, class_name: 'Admin::Category', foreign_key: :parent_id, dependent: :destroy
  belongs_to :category, class_name: 'Admin::Category', foreign_key: :parent_id, required: false
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  private

  def set_permalink
    if category.present?
      update_column(:permalink, category.permalink + '/' + slug)
    else
      update_column(:permalink, slug)
    end
  end

  def self.menu
    self.where('parent_id is NULL')
  end

end
