# frozen_string_literal: true

module Ops
  module Developer
    module Screening
      # Persists the result of completed task
      class CompleteTask < BaseOperation
        step :persist_result!
        success :complete_screening!

        private

        def persist_result!(ctx, user:, assignment_id:, params:, **)
          ctx[:model] = user.test_task_assignments.find(assignment_id)
          result = ctx[:model].create_test_task_result(params)
          result.valid?
        end

        # TODO: rework passing role
        def complete_screening!(_ctx, user:, **)
          Finish.call(user: user)
        end
      end
    end
  end
end
