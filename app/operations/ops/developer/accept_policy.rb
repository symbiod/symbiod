# frozen_string_literal: true

module Ops
  module Developer
    # When user accept policy, save it in state
    class AcceptPolicy < BaseOperation
      step :accept_policy!

      private

      def accept_policy!(_ctx, user:, params:, **)
        return unless params[:accept_policy] == '1'
        user.accept_policy
        user.save(validate: false)
      end
    end
  end
end
