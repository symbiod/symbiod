# frozen_string_literal: true

module Ops
  module Developer
    # This is class to calculate percent onboarding progress users
    class OnboardingProgress
      def initialize(user)
        @user = user
      end

      def percent
        total = @user.test_task_assignments.size || Ops::Developer::Screening::NUMBER_OF_ASSIGNED_TEST_TASKS
        done = @user.test_task_assignments.completed.size
        done += 1 if @user.developer_onboarding.try(:slack)
        done += 1 if @user.developer_onboarding.try(:github)
        100 * done / (total + 2)
      end
    end
  end
end
