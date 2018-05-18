module Bootcamp
  module Wizard
    class ProfilePolicy < ApplicationPolicy
      def edit?
        user&.pending?
      end
    end
  end
end
