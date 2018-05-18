module Bootcamp
  module Wizard
    class ScreeningPolicy < ApplicationPolicy
      def edit?
        user&.profile_completed?
      end
    end
  end
end
