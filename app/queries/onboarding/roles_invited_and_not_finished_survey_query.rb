# frozen_string_literal: true

module Onboarding
  # Find users where invited and finished survey
  class RolesInvitedAndNotFinishedSurveyQuery

    FEEDBACK_STATUS = 'feedback_pending'

    def self.call
      Role.select(:user_id)
        .joins(user: :member_onboarding)
        .group(:user_id)
        .where(member_onboardings: { feedback_status: FEEDBACK_STATUS })
    end
  end
end
