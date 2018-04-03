# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  body        :text(65535)
#  user_id     :integer
#  is_approved :boolean
#  blog_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :user
end
