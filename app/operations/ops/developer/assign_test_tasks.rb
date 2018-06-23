# frozen_string_literal: true

module Ops
  module Developer
    # Get random test task depending on skill and position
    class AssignTestTasks < BaseOperation
      step :create_test_task_assignments!

      private

      def create_test_task_assignments!(_ctx, user:, positions:, **)
        @user = user
        @positions = positions
        test_tasks.each do |test_task|
          user.test_task_assignments.create!(test_task: test_task)
        end
      end

      def test_tasks
        # TODO: potentially unsafe picking just first role
        # we need probably to pass which role do we want to assign.
        # ATM not sure how to figure out that.
        (1..@positions).inject([]) do |test_tasks, position|
          test_tasks << ::Developer::TestTask.active.where(
            position: position,
            role_name: @user.roles_name.first,
            skill_id: @user.primary_skill.id
          ).sample
        end.compact
      end
    end
  end
end
