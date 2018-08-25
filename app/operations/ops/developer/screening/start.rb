# frozen_string_literal: true

module Ops
  module Member
    module Screening
      # Screening process assings test tasks for member
      class Start < BaseOperation
        NUMBER_OF_ASSIGNED_TEST_TASKS = 2

        step :assign_test_tasks!

        private

        def assign_test_tasks!(_ctx, user:, **)
          Ops::Member::AssignTestTasks.call(user: user, positions: NUMBER_OF_ASSIGNED_TEST_TASKS)
        end
      end
    end
  end
end
