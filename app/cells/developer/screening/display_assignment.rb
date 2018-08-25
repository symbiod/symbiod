# frozen_string_literal: true

module Member
  module Screening
    # This cell renders a single screening assignment
    class DisplayAssignment < BaseCell
      def assignment
        model.test_task_result || Member::TestTaskResult.new
      end
    end
  end
end
