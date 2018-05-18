# frozen_string_literal: true

module Developer
  # Sends mail to notify about start of onboarding
  class OnboardingStartedMailer < ApplicationMailer
    def notify(user)
      @user = user
      mail(
        to: @user.email,
        subject: "#{t('bootcamp.onboarding.started')}, #{user.full_name}"
      )
    end
  end
end
