# frozen_string_literal: true

module Ops
  module Roles
    # In some cases the member might be stuck at some state.
    # It can be caused by some bug, that leads to the data inconsistency,
    # or because of user inactivity or unability to finish screening.
    # For such exceptional cases we want to provide staff an ability
    # to activate user, without checking his current state.
    class ForceActivate < ::Ops::Member::Activate
      private

      # TODO: rework by passing role instead of user
      def change_state!(_ctx, user:, **)
        role(user).update!(state: 'active')
      end
    end
  end
end
