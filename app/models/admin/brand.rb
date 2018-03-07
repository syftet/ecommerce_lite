class Admin::Brand < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :products, dependent: :destroy

  after_save :set_permalink
  before_destroy :check_product

  private

  def set_permalink
    update_column(:permalink, slug)
  end

  def check_product
    !products.present?
    # if products.present?
    #   products.update_all(is_active: false)
    #   update_attributes(is_active: false)
    #   false
    # end
  end
end
