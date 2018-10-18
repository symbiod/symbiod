# frozen_string_literal: true

module Member
  # Sends mail to notify about unfinished survey
  class UnfinishedSurveyMailer < ApplicationMailer
    def notify(role_id)
      @role = Role.find(role_id)
      mail(
          to: @role.user.email,
          subject: "#{t('bootcamp.onboarding.survey_unfinished_title')}"
      )
    end
  end
end
