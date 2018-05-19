# frozen_string_literal: true

module Ops
  module Developer
    module Screening
      # Marks user as completed screening and notifies staff about new results
      class Finish < BaseOperation
        step :all_tasks_completed?
        success :complete_screening!

        private

        def all_tasks_completed?(_ctx, user:, **)
          user.test_tasks_completed?
        end

        def complete_screening!(_ctx, user:, **)
          user.complete_screening!
        end
      end
    end
  end
end
