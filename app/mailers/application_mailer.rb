class ApplicationMailer < ActionMailer::Base
  default from: 'john@test.com'
  layout 'mailer'
end
