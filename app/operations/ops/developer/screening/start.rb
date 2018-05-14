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
          test_tasks.each do |task|
            user.test_task_assignments.create!(test_task: task)
          end
        end

        def test_tasks
          test_tasks = []
          NUMBER_OF_ASSIGNED_TEST_TASKS.times { |i| test_tasks << ::Developer::TestTask.where(position: i + 1).sample }
          test_tasks
        end
      end
    end
  end
end
