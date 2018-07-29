# frozen_string_literal: true

module Bootcamp
  module Wizard
    # Defines access rules to profile editing wizard page
    # TODO: maybe rename this class to make the name more cute?
    class AcceptPolicyPolicy < ApplicationPolicy
      def edit?
        return unless user
        # TODO: this looks like a problem, think about it
        Roles::RolesManager.new(user).role_for(:developer)&.profile_completed? ||
          Roles::RolesManager.new(user).role_for(:mentor)&.profile_completed?
      end
    end
  end
end
