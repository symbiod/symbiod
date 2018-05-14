# frozen_string_literal: true

# frozen_string_literal : true

module Web
  module Dashboard
    # Management test tasks
    class TestTasksController < BaseController
      before_action :find_test_task, only: %i[edit update]
      before_action :authorize_staff!

      def index
        @developer_test_tasks = Developer::TestTask.order(id: :asc)
      end

      def edit; end

      def update
        if @developer_test_task.update(developer_test_task_params)
          redirect_to dashboard_test_tasks_url
          flash[:success] = t('dashboard.developer_test_task.notices.update')
        else
          render 'edit'
        end
      end

      private

      def developer_test_task_params
        params.require(:developer_test_task).permit(:title, :description)
      end

      def find_test_task
        @developer_test_task = Developer::TestTask.find(params[:id])
      end

      def authorize_staff!
        authorize :test_task, "#{action_name}?".to_sym
      end
    end
  end
end
