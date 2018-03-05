class NewsletterSubscription < ApplicationRecord
  validates :email, presence: true
  after_create :send_notification

  def send_notification
    NotificationMailer.send_subscription_notification(self.email).deliver_now
  end
end
