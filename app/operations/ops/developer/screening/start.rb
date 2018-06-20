# frozen_string_literal: true

module Ops
  module Developer
    module Screening
      # Screening process assings test tasks for developer
      class Start < BaseOperation
        NUMBER_OF_ASSIGNED_TEST_TASKS = 2

        step :assign_test_tasks!

        private

        def assign_test_tasks!(_ctx, user:, **)
          Ops::Developer::AssignTestTasks.call(user: user, positions: NUMBER_OF_ASSIGNED_TEST_TASKS)
        end
      end
    end
  end
end
