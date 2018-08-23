# frozen_string_literal: true

module Dashboard
  # This policy manage access to manage questions feedback
  class FeedbackQuestionPolicy < DashboardPolicy
    def index?
      staff?
    end

    alias new? index?
    alias create? index?
    alias edit? index?
    alias update? index?
    alias destroy? index?
  end
end
