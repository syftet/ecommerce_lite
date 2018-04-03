# == Schema Information
#
# Table name: feedbacks
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  email            :string(255)
#  feedback_type    :string(255)
#  message          :text(65535)
#  product_quality  :string(255)
#  product_price    :string(255)
#  customer_service :text(65535)
#  rate             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Feedback < ApplicationRecord
end
