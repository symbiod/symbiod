# frozen_string_literal: true

module Ideas
  # Defines access rules to new idea
  class ProposalPolicy < ApplicationPolicy
    def index?
      user.present?
    end

    def create?
      user&.ideas&.empty? && author?
    end

    private

    def author?
      user.has_role? :author
    end
  end
end
