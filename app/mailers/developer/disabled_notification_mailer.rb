# frozen_string_literal: true

module Member
  # Sends mail to notify about rejection
  class DisabledNotificationMailer < ApplicationMailer
    def notify(user_id)
      @user = User.find(user_id)
      mail(to: @user.email, subject: t('dashboard.users.mailers.disabled.subject'))
    end
  end
end
