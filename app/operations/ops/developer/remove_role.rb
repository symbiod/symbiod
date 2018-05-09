# frozen_string_literal: true

module Ops
  module Developer
    # This remove role to user
    class RemoveRole < BaseOperation
      step :remove_role!

      private

      def remove_role!(_ctx, user:, role:, size:, **)
        user.remove_role role if size > 1
      end
    end
  end
end
