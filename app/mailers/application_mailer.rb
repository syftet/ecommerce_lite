class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  add_template_helper(ProductHelper)
  layout 'mailer'
end
