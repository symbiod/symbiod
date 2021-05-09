# frozen_string_literal: true

module Web
  module Dashboard
    # This class manage projects
    class ProjectsController < BaseController
      before_action :project_find, only: %i[show edit update]
      before_action only: :index do
        authorize_role(%i[dashboard project])
      end

      def index
        @projects = ::Dashboard::ProjectPolicy::Scope.new(current_user, Project).resolve
      end

      def show; end

      def edit
        @stacks = Stack.all
      end

      def update
        if @project.update(project_params)
          redirect_to dashboard_project_url(@project),
                      flash: { success: t('dashboard.projects.update.success') }
        else
          flash.now[:danger] = t('dashboard.projects.update.danger')
          render :edit
        end
      end

      private

      def project_params
        params.require(:project).permit(:name, :stack_id, :slug)
      end

      def project_find
        @project ||= Project.find(params[:id])
        authorize @project, policy_class: ::Dashboard::ProjectPolicy
      end
    end
  end
end
