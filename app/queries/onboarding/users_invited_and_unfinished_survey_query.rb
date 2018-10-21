# frozen_string_literal: true

module Onboarding
  # Find users where invited and finished survey
  class UsersInvitedAndUnfinishedSurveyQuery
    def call
      unfinished_survey_roles
    end

    private

    def unfinished_survey_roles
      Role
        .joins(user: :member_onboarding)
        .where(member_onboardings: { feedback_status: 'feedback_pending' }).distinct
    end
  end
end
