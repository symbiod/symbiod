# frozen_string_literal: true

module Dashboard
  # Voting policy for an idea
  class VotePolicy < DashboardPolicy
    def index?
      true
    end

    def up?
      current_user_allow_voting?
    end

    alias down? up?

    def voting_panel?
      record.voting?
    end

    private

    def current_user_allow_voting?
      developer? && user.votes.where(idea_id: record.id).empty? && record.voting?
    end
  end
end
