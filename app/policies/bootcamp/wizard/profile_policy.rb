# frozen_string_literal: true

module Bootcamp
  module Wizard
    # Defines access rules to profile editing wizard page
    class ProfilePolicy < ApplicationPolicy
      def edit?
        return unless user
        user.roles
            .where(state: 'pending', type: Rolable.member_roles_class_names)
            .any? ||
        user.roles.where(type: Rolable.member_roles_class_names).empty?
      end
    end
  end
end
