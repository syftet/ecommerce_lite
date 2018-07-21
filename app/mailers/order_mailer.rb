class OrderMailer < ApplicationMailer
  default "Message-ID" => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@ornahousebd.com"
  default from: "ornahousebd.com <sales@ornahousebd.com>"
  helper ApplicationHelper
  helper ProductHelper

  def confirm_email(order, resend = false)
    @order = order.respond_to?(:id) ? order : Order.find(order)
    mail(to: 'nazrulku07@gmail.com', subject: 'Your Orna House Order Confirmation')
    #unless resend
      #mail(to: 'nazrulku07@gmail.com', subject: 'New order received from www.ornahousebd.com') #, delivery_method_options: Order::ORDER_SMTP)
    #end
  end

  def update_order(order)
    @order = order
    subject = "Your Orna House order status has been updated"
    mail(to: @order.email, subject: subject, delivery_method_options: Order::ORDER_SMTP)
  end

  def cancel_email(order, resend = false)
    @order = order.respond_to?(:id) ? order : Order.find(order)
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "#{Store.current.name} #{t('order_mailer.cancel_email.subject')} ##{@order.number}"
    mail(to: @order.email, subject: subject, delivery_method_options: Order::ORDER_SMTP)
  end
end
