# frozen_string_literal: true

module Web
  module Dashboard
    # Management test tasks
    class TestTasksController < BaseController
      before_action :find_test_task, only: %i[edit update activate deactivate]
      before_action :find_user_roles, only: %i[index new edit]
      before_action do
        authorize_role(:test_task)
      end

      def index
        @member_test_tasks = Member::TestTask.order(id: :asc)
      end

      def new
        @member_test_task = Member::TestTask.new
      end

      def create
        @member_test_task = Member::TestTask.new(member_test_task_params)
        if @member_test_task.save
          redirect_to dashboard_test_tasks_url,
                      flash: { success: "#{t('dashboard.member_test_task.notices.create')}:
                                        #{@member_test_task.title}" }
        else
          render 'new'
        end
      end

      def edit; end

      def update
        if @member_test_task.update(member_test_task_params)
          redirect_to dashboard_test_tasks_url,
                      flash: { success: "#{t('dashboard.member_test_task.notices.update')}:
                                        #{@member_test_task.title}" }
        else
          render 'edit'
        end
      end

      def activate
        @member_test_task.activate!
        redirect_to dashboard_test_tasks_url,
                    flash: { success: "#{t('dashboard.member_test_task.notices.activated')}:
                                      #{@member_test_task.title}" }
      end

      def deactivate
        @member_test_task.disable!
        redirect_to dashboard_test_tasks_url,
                    flash: { success: "#{t('dashboard.member_test_task.notices.deactivated')}:
                                      #{@member_test_task.title}" }
      end

      private

      def member_test_task_params
        params.require(:member_test_task).permit(:title, :description, :position, :role_name, :skill_id)
      end

      def find_test_task
        @member_test_task = Member::TestTask.find(params[:id])
      end

      def find_user_roles
        @roles = Roles::RolesManager::MEMBER_ROLES
      end
    end
  end
end
