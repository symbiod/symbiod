# frozen_string_literal: true

# Base mailer class, email 'from' defined
class ApplicationMailer < ActionMailer::Base
  default from: Settings.notifications.email.default_from
  layout 'mailer'
end
