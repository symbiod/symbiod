# frozen_string_literal: true

module Onboarding
  # Find users where invited and finished survey
  class UsersInvitedAndFinishedSurveyQuery < BaseOnboardingQuery
    class << self
      private

      def query_condition
        { feedback_status: %w[feedback_pending feedback_completed] }
      end
    end
  end
end
