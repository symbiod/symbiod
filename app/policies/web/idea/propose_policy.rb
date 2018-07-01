# frozen_string_literal: true

module Web
  module Idea
    # Defines access rules to new idea
    class ProposePolicy < ApplicationPolicy
      def index?
        true
      end

      def new?
        user.ideas.size.zero?
      end

      def create?
        user.ideas.size.zero?
      end
    end
  end
end
