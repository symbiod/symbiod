# frozen_string_literal: true

module Onboarding
  # Find users where invited and finished survey
  class UsersInvitedAndUnfinishedSurveyQuery
    def call
      unfinished_survey_users
    end

    private

    def unfinished_survey_users
      Member::Onboarding
          .joins(:user, :role)
          .where(feedback_status: 'feedback_pending')
    end
  end
end
