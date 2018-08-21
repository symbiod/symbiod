# frozen_string_literal: true

module Dashboard
  # Policy feedback users after onboarding
  class SurveyResponsePolicy < DashboardPolicy
    def index?
      staff?
    end

    alias show? index?

    def new?
      return unless developer?
      user.role(:developer).survey_response.nil?
    end

    alias create? new?
  end
end
