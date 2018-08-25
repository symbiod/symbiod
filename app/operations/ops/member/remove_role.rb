# frozen_string_literal: true

module Ops
  module Member
    # Removes the role from user
    class RemoveRole < BaseOperation
      step :remove_role!

      private

      def remove_role!(_ctx, user:, role:, size:, **)
        return user.remove_role role if size > 1
        raise Ops::Member::UnassignRole::LastRoleError
      end
    end
  end
end
