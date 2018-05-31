# frozen_string_literal: true

# frozen_string_literal : true

module Web
  module Dashboard
    # Management test tasks
    class TestTasksController < BaseController
      before_action :find_test_task, only: %i[edit update destroy]
      before_action :find_user_roles, only: %i[index new edit]
      before_action :authorize_staff!

      def index
        @developer_test_tasks = Developer::TestTask.order(id: :asc)
      end

      def new
        @developer_test_task = Developer::TestTask.new
      end

      def create
        @developer_test_task = Developer::TestTask.new(developer_test_task_params)
        if @developer_test_task.save
          redirect_to dashboard_test_tasks_url
          flash[:success] = t('dashboard.developer_test_task.notices.create')
        else
          render 'new'
        end
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

      def destroy
        @developer_test_task.destroy
        redirect_to dashboard_test_tasks_url
        flash[:success] = t('dashboard.developer_test_task.notices.destroy')
      end

      private

      def developer_test_task_params
        params.require(:developer_test_task).permit(:title, :description, :position, :role_id)
      end

      def find_test_task
        @developer_test_task = Developer::TestTask.find(params[:id])
      end

      def find_user_roles
        @roles = Role.all
      end

      def authorize_staff!
        authorize :test_task, "#{action_name}?".to_sym
      end
    end
  end
end
