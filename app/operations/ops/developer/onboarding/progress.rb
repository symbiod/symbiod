# frozen_string_literal: true

module Ops
  module Developer
    class Onboarding
      # This is class to calculate percent onboarding progress users
      class Progress
        def initialize(user)
          @user = user
        end

        def percent
          100 * steps_done / total_steps
        end

        private

        def total_steps
          count_test_tasks + ::Developer::Onboarding::COUNT_TASKS
        end

        def count_test_tasks
          @user.test_task_assignments.size || Ops::Developer::Screening::NUMBER_OF_ASSIGNED_TEST_TASKS
        end

        def steps_done
          (test_tasks_completed + tasks_after_onboarding_completed).count { |i| i }
        end

        def test_tasks_completed
          @user.test_task_assignments.map(&:completed?)
        end

        def tasks_after_onboarding_completed
          return [] unless @user.developer_onboarding
          [
            @user.developer_onboarding.slack_completed,
            @user.developer_onboarding.github_completed,
            @user.developer_onboarding.feedback_completed
          ]
        end
      end
    end
  end
end
