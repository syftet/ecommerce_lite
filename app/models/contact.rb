# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  full_name       :string(255)
#  email      :string(255)
#  phone    :string
#  phone    :string
#  order_number    :string
#  inquiry_type    :string
#  message    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Contact < ApplicationRecord
  after_create :send_email_notification

  def send_email_notification
    NotificationMailer.send_contact_notification(self).deliver_now
  end
end
