# frozen_string_literal: true

module Dashboard
  # Policy feedback users after onboarding
  class SurveyResponsePolicy < DashboardPolicy
    def index?
      staff?
    end

    alias show? index?

    def new?
      user.survey_response.nil?
    end

    alias create? new?
  end
end
