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

require 'test_helper'

class Admin::BrandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
