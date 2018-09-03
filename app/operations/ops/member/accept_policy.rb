# frozen_string_literal: true

module Ops
  module Member
    # When user accept policy, save it in state
    class AcceptPolicy < ::Ops::Member::BaseOperation
      step :accept_policy!
      step :start_screening!

      private

      def accept_policy!(_ctx, user:, params:, **)
        return unless params[:accept_policy] == '1'
        role(user).accept_policy!
      end

      def start_screening!(_ctx, user:, **)
        Ops::Member::Screening::Start.call(user: user)
      end
    end
  end
end
