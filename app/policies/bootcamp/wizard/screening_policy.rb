# frozen_string_literal: true

module Bootcamp
  module Wizard
    # Defines the rules by which user can access screening page
    # on sign up wizard
    class ScreeningPolicy < ApplicationPolicy
      def edit?
        user&.profile_completed? || user&.screening_completed?
      end
    end
  end
end
