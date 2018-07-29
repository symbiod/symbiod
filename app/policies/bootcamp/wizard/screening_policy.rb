# frozen_string_literal: true

module Bootcamp
  module Wizard
    # Defines the rules by which user can access screening page
    # on sign up wizard
    class ScreeningPolicy < ApplicationPolicy
      # We allow user with `policy_accepted` state to access screening,
      # because it is the previous step before screening.
      # And we allow user with `screening_completed` to access screening
      # page, because we need to display message for him, while he is waiting
      # for approval.
      def edit?
        return unless user
        user.roles
            .where(
              state: %w[screening_completed policy_accepted],
              type: Rolable.member_roles_class_names
            )
            .any?
      end
    end
  end
end
