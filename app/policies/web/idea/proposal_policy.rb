# frozen_string_literal: true

module Web
  module Idea
    # Defines access rules to new idea
    class ProposalPolicy < ApplicationPolicy
      def index?
        true
      end

      def create?
        user.ideas.empty?
      end
    end
  end
end
