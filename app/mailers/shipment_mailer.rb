class ShipmentMailer < ApplicationMailer
  default from: "lienesbeauty.com <sales@lienesbeauty.com>"

  def shipped_email(shipment, resend = false)
    @shipment = shipment.respond_to?(:id) ? shipment : Shipment.find(shipment)
    subject = (resend ? "[#{I18n.t(:resend).upcase}] " : '')
    subject += "#{Store.current.name} #{I18n.t('shipment_mailer.shipped_email.subject')} ##{@shipment.order.number}"
    mail(to: @shipment.order.email, subject: subject, delivery_method_options: Order::ORDER_SMTP)
  end
end