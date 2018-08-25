# frozen_string_literal: true

module Ops
  module Member
    # This add role to user
    class AssignRole < BaseOperation
      step :add_role!

      private

      def add_role!(_ctx, user:, role:, **)
        user.add_role role
      end
    end
  end
end
