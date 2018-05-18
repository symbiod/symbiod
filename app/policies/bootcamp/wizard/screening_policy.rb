module Bootcamp
  module Wizard
    class ScreeningPolicy < ApplicationPolicy
      def edit?
        user&.profile_completed? || user&.screening_completed?
      end
    end
  end
end
