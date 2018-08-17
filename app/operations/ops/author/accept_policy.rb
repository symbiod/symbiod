# frozen_string_literal: true

module Ops
  module Author
    # This operation conditionally changes role state from `pending`
    # to `policy_accepted`.
    # It requires `author` argument, that should be an instance of `Role::Author`
    # and `params` hash, that contains `accept_policy` key.
    class AcceptPolicy < BaseOperation
      step :change_state!

      private

      def change_state!(_ctx, author:, params:, **)
        return unless policy_accepted?(params)
        author.accept_policy!
      end

      def policy_accepted?(params)
        params[:accept_policy] == '1'
      end
    end
  end
end
