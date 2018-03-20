class UserMailer < ApplicationMailer
  default "Message-ID" => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@lienesbeuty.com"

  def welcome(user)
    @user = user
    mail(to: user.email, from: 'shop@lienesbeauty.com', subject: 'Welcome To Lienesbeuty.com')
  end

  def reset_password_instructions(user, token, *args)
    @edit_password_reset_url = edit_user_password_url(:reset_password_token => token)
    @user = user
    mail to: user.email, from: 'shop@lienesbeauty.com', subject: 'Lienesbeauty ' + I18n.t(:subject, :scope => [:devise, :mailer, :reset_password_instructions])
  end

end
