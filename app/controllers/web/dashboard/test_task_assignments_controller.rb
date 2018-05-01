# frozen_string_literal: true

module Web
  module Dashboard
    # Handles all management logic for newcomers
    class TestTaskAssignmentsController < BaseController
      before_action :candidate, only: %i[show activate reject]

      def index
        @candidates = User.screening_completed
      end

      def show; end

      def activate
        Ops::Developer::Activate.call(user: @candidate)
        redirect_to dashboard_test_task_assignments_url, notice: t('dashboard.candidates.notices.activated')
      end

      def reject
        Ops::Developer::Reject.call(user: @candidate, feedback: rejection_params[:feedback])
        redirect_to dashboard_test_task_assignments_url, notice: t('dashboard.candidates.notices.rejected')
      end

      private

      def candidate
        @candidate ||= User.find(params[:id])
      end

      def rejection_params
        params.require(:developer_test_task_assignment).permit(:feedback)
      end
    end
  end
end
