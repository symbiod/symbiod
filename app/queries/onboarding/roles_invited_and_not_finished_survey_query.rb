# frozen_string_literal: true

module Onboarding
  # Find users where invited and finished survey
  class RolesInvitedAndNotFinishedSurveyQuery

    FEEDBACK_STATUS = 'feedback_pending'

    def self.call
      Role
        .joins(user: :member_onboarding)
        .where(member_onboardings:
          { feedback_status: FEEDBACK_STATUS }).distinct
    end
  end
end
