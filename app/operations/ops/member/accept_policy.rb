# frozen_string_literal: true

module Ops
  module Member
    # When user accept policy, save it in state
    class AcceptPolicy < ::Ops::Member::BaseOperation
      step :accept_policy!

      private

      def accept_policy!(_ctx, user:, params:, **)
        return unless params[:accept_policy] == '1'
        role(user).accept_policy!
      end
    end
  end
end
