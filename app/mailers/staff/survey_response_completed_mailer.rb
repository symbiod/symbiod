# frozen_string_literal: true

module Staff
  # Sends mail notify about completed of feedback after onboarding
  class SurveyResponseCompletedMailer < ApplicationMailer
    add_template_helper(ProfileHelper)

    default to: -> { User.with_role(:staff).pluck(:email) }

    def notify(user_id)
      @user = User.find(user_id)
      mail(subject: 'User left feedback after onboarding')
    end
  end
end
