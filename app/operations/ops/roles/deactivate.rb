# frozen_string_literal: true

module Ops
  module Roles
    # This operation deactivates roles
    class Deactivate < BaseOperation
      step :change_state!

      private

      def change_state!(_ctx, role:, **)
        role.disable!
      end
    end
  end
end
