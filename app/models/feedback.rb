# == Schema Information
#
# Table name: feedback
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  type    :string
#  message    :text
#  product_quality   :string
#  product_price    :string
#  cutomer_service    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Feedback < ApplicationRecord
end
