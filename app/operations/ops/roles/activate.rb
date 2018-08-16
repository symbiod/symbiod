# frozen_string_literal: true

module Ops
  module Roles
    # This operation activates roles
    class Activate < BaseOperation
      step :change_state!

      private

      def change_state!(_ctx, role:, **)
        role.activate!
      end
    end
  end
end
