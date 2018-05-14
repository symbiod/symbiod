# frozen_string_literal: true

module Developer
  # Sends mail to notify about rejection
  class RejectionNotificationMailer < ApplicationMailer
    def notify(user, feedback)
      @user = user
      @feedback = feedback
      mail(to: @user.email, subject: "#{t('bootcamp.screening.rejection')}, #{user.name}")
    end
  end
end
