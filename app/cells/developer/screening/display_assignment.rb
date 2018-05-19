# frozen_string_literal: true

module Developer
  module Screening
    # This cell renders a single screening assignment
    class DisplayAssignment < BaseCell
      def assignment
        model.test_task_result || Developer::TestTaskResult.new
      end
    end
  end
end
