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
          test_tasks(user).compact.each do |task|
            user.test_task_assignments.create!(test_task: task)
          end
        end

        def test_tasks(user)
          # We select one task for each priority, depending on NUMBER_OF_ASSIGNED_TEST_TASKS
          (1..NUMBER_OF_ASSIGNED_TEST_TASKS).inject([]) do |tasks, i|
            tasks << ::Developer::TestTask.active.where(position: i, role_id: user.role_ids.first).sample
          end
        end
      end
    end
  end
end
