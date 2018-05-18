# frozen_string_literal: true

module Web
  module Bootcamp
    module Wizard
      # Allows newcomer to fill screening tasks survey
      class ScreeningsController < BaseController
        def index
          @assignment = current_user.test_task_assignments.uncompleted.first
        end

        # TODO: authorize if user is able to pass current assignment
        def update
          Ops::Developer::Screening::CompleteTask.call(
            user: current_user,
            assignment_id: params[:id],
            params: assignment_result.to_hash
          )
          redirect_to bootcamp_wizard_screenings_url
        end

        private

        def assignment_result
          params.require(:developer_test_task_result).permit(:link)
        end

        def policy_class
          ::Bootcamp::Wizard::ScreeningPolicy
        end
      end
    end
  end
end
