# frozen_string_literal: true

module Web
  module Bootcamp
    # Allows newcomer to fill screening tasks survey
    class ScreeningsController < BaseController
      before_action :require_login

      def index
        @assignment = current_user.test_task_assignments.uncompleted.first
      end

      def update
        Ops::Developer::Screening::CompleteTask.call(
          user: current_user,
          assignment_id: params[:id],
          params: assignment_result.to_hash
        )
        redirect_to bootcamp_screenings_url
      end

      private

      def assignment_result
        params.require(:developer_test_task_result).permit(:link)
      end
    end
  end
end
