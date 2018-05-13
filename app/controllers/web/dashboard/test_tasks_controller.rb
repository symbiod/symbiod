# frozen_string_literal : true

module Web
  module Dashboard
    class TestTasksController < BaseController
      before_action :test_task_find, only: %i[edit update]
      before_action :authorize_staff!

      def index
        @developer_test_tasks = Developer::TestTask.all
      end

      def edit; end

      def update; end

      private

      def test_task_params
        params.require(:developer_test_task).permit(:description)
      end

      def test_task_find
        @developer_test_task = Developer::TestTask.find(params[:id])
      end

      def authorize_staff!
        authorize :test_task, "#{action_name}?".to_sym
      end
    end
  end
end
