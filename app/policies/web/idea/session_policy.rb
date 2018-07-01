# frozen_string_literal: true

module Web
  module Idea
    # Defines access rules to login in author
    class SessionPolicy < ApplicationPolicy
      def new?
        user.nil?
      end

      def create?
        user.nil?
      end
    end
  end
end
