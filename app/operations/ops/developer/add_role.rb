# frozen_string_literal: true

module Ops
  module Developer
    # This add role to user
    class AddRole < BaseOperation
      step :add_role!

      private

      def add_role!(_ctx, user:, role:, **)
        user.add_role role
      end
    end
  end
end
