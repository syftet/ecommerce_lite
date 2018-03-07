class Admin::Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  after_save :set_permalink

  has_many :sub_categories, class_name: 'Admin::Category', foreign_key: :parent_id, dependent: :destroy
  belongs_to :category, class_name: 'Admin::Category', foreign_key: :parent_id, required: false
  has_many :product_categories
  has_many :products, through: :product_categories

  private

  def set_permalink
    if category.present?
      update_column(:permalink, category.permalink + '/' + slug)
    else
      update_column(:permalink, slug)
    end
  end
end
