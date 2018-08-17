# frozen_string_literal: true

module Dashboard
  # Policy feedback users after onboarding
  class SurveyResponsePolicy < DashboardPolicy
    def show?
      staff_or_mentor?
    end

    def new?
      user.survey_response.nil?
    end

    alias create? new?
  end
end
