# == Schema Information
#
# Table name: admin_categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  description :string(255)
#  permalink   :string(255)
#  meta_title  :string(255)
#  meta_desc   :string(255)
#  keywords    :string(255)
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class Admin::CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
