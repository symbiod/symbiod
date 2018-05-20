# frozen_string_literal: true

module Ops
  module Developer
    # This is class to calculate percent onboarding progress users
    class OnboardingProgress
      def initialize(user)
        @user = user
      end

      def percent
        100 * steps_done / total_steps
      end

      private

      def total_steps
        total = @user.test_task_assignments.size || Ops::Developer::Screening::NUMBER_OF_ASSIGNED_TEST_TASKS
        # We add 2 because of slack and github
        total + 2
      end

      def steps_done
        steps = @user.test_task_assignments.map(&:completed?) +
                [@user.developer_onboarding.try(:slack), @user.developer_onboarding.try(:github)]
        steps.count { |i| i }
      end
    end
  end
end
