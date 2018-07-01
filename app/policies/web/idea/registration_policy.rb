# frozen_string_literal: true

module Web
  module Idea
    # Defines access rules to create author
    class RegistrationPolicy < ApplicationPolicy
      def new?
        user.nil?
      end

      def create?
        user.nil?
      end
    end
  end
end
