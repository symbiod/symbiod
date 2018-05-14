# frozen_string_literal: true

# Base mailer class, email 'from' defined
class ApplicationMailer < ActionMailer::Base
  default from: 'givemepoc@gmail.com'
  layout 'mailer'
end
