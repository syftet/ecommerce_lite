class NotificationMailer < ApplicationMailer

  def send_contact_notification(contact)
    @contact = contact
    mail(to: 'shop@lienesbeauty.com', subject: "Contact request from: #{@contact.email}", from: 'shop@lienesbeauty.com')
  end

  def send_subscription_notification(email)
    @email = email
    mail(to: email, subject: "Lienesbeauty subscription gift", from: 'shop@lienesbeauty.com')
  end

end
