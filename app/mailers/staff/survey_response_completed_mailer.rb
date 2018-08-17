# frozen_string_literal: true

module Staff
  # Sends mail notify about completed of feedback after onboarding
  class SurveyResponseCompletedMailer < ApplicationMailer
    add_template_helper(ProfileHelper)

    default to: -> { Users::ScreeningCompletedNotificationRecipientsQuery.new(@user).call.pluck(:email) }

    def notify(user_id)
      @user = User.find(user_id)
      mail(subject: t('dashboard.survey_responses.notices.completed'))
    end
  end
end
