# frozen_string_literal: true

module Onboarding
  # Find users where invited and joined status to GitHub
  class BaseOnboardingQuery
    def self.call
      User
        .joins(:member_onboarding)
        .where(member_onboardings: query_condition)
    end
  end
end
