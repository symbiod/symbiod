# frozen_string_literal: true

module Ideas
  module Wizard
    # Defines access rules to new idea
    class ProposalPolicy < ApplicationPolicy
      def authorized?
        create?
      end

      def index?
        user.present?
      end

      def create?
        author?
      end

      private

      def author?
        user.has_role? :author
      end
    end
  end
end
