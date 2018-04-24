class ShipmentMailer < ApplicationMailer
  default from: "lienesbeauty.com <sales@lienesbeauty.com>"

  def shipped_email(shipment, resend = false)
    @shipment = shipment.respond_to?(:id) ? shipment : Shipment.find(shipment)
    subject = (resend ? "[#{I18n.t(:resend).upcase}] " : '')
    subject += " #{I18n.t('shipment_mailer.shipped_email.subject')} ##{@shipment.order.number}"
    @shipment.order.email.present? ? email = @shipment.order.email : email = @shipment.order.user.email
    mail(to: email, subject: subject, delivery_method_options: Order::ORDER_SMTP)
  end
end
#{Store.current.name}