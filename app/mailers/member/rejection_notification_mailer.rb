# frozen_string_literal: true

module Member
  # Sends mail to notify about rejection
  class RejectionNotificationMailer < ApplicationMailer
    def notify(user_id, feedback)
      @user = User.find(user_id)
      @feedback = feedback
      mail(to: @user.email, subject: "#{t('specialists.screening.rejection')}, #{@user.full_name}")
    end
  end
end
