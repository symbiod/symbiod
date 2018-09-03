# frozen_string_literal: true

module Ops
  module Member
    # Get random test task depending on skill and position
    class AssignTestTasks < BaseOperation
      step :find_test_tasks!
      failure :complete_screening!
      success :setup_test_task_assignments!

      private

      def find_test_tasks!(ctx, user:, positions:, **)
        ctx[:test_tasks] = TestTasks::ForApplicationQuery.new(positions, user).call
        ctx[:test_tasks].present?
      end

      def complete_screening!(_ctx, user:, **)
        Ops::Member::Screening::Finish.call(user: user)
      end

      def setup_test_task_assignments!(ctx, user:, **)
        ctx[:test_tasks].each do |test_task|
          user.test_task_assignments.create!(test_task: test_task)
        end
      end
    end
  end
end
