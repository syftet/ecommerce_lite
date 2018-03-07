class Admin::Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  after_save :set_permalink

  has_many :sub_categories, class_name: 'Admin::Category', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :category, class_name: 'Admin::Category', foreign_key: 'parent_id', required: false

  private

  def set_permalink
    if self.category.present?
      self.update_column(:permalink, self.category.permalink + '/' + self.slug)
    else
      self.update_column(:permalink, self.slug)
    end
  end
end
