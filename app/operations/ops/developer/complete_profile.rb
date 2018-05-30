# frozen_string_literal: true

module Ops
  module Developer
    # Persists passed data and starts screening
    # bases on chosen technologies
    class CompleteProfile < BaseOperation
      step :persist_profile_data!
      success :assign_mentor_role!
      success :complete_profile!
      success :start_screening!

      private

      def persist_profile_data!(_ctx, user:, params:, **)
        user.update(params)
      end

      def assign_mentor_role!(_ctx, user:, **)
        user.add_role(:mentor) if user.mentor
      end

      def complete_profile!(_ctx, user:, **)
        user.complete_profile!
      end

      def start_screening!(_ctx, user:, **)
        Ops::Developer::Screening::Start.call(user: user)
      end
    end
  end
end
