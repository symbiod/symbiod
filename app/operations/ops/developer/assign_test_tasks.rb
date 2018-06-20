# frozen_string_literal: true

module Ops
  module Developer
    # Get random test task depending on skill and position
    class AssignTestTasks < BaseOperation

      step random_test_tasks!

      private

      def random_test_tasks!(_ctx, user:, positions:, **)
        (1..positions).each do |position|
          ::Developer::TestTask.active.where(
            position: position,
            role_id: user.role_ids.first,
            skill_id: user.primary_skill.id
          ).sample
        end
      end
    end
  end
end
