# frozen_string_literal: true

module Ops
  module Developer
    module Screening
      # Persists the result of completed task
      class CompleteTask < BaseOperation
        step :persist_result!
        success :complete_screening!

        private

        def persist_result!(_ctx, user:, assignment_id:, params:, **)
          assignment = user.test_task_assignments.find(assignment_id)
          result = ::Developer::TestTaskResult.create!(params)
          assignment.update!(test_task_result: result)
        end

        def complete_screening!(_ctx, user:, **)
          Finish.call(user: user)
        end
      end
    end
  end
end
