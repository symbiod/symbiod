# frozen_string_literal: true

module Web
  module Dashboard
    # Assigns the role to the user
    class UsersController < BaseController
      before_action :user_find, except: :index
      before_action :authorize_role
      rescue_from Pundit::NotAuthorizedError, with: :redirect_to_dashboard_root
      rescue_from Ops::Developer::UnassignRole::LastRoleError, with: :redirect_to_dashboard_user

      def index
        @users = User.newer_first.page params[:page]
      end

      def show
        @roles = Role.all
        @test_task_assignments = @user.test_task_assignments.order(id: :asc)
      end

      def edit; end

      def update
        if @user.update(user_params)
          redirect_to dashboard_user_url, success: t('dashboard.user.update.flash.success')
        else
          render :edit
        end
      end

      def activate
        Ops::Developer::Activate.call(user: @user)
        redirect_to dashboard_users_url,
                    flash: { success: "#{t('dashboard.users.notices.activated')}: #{@user.email}" }
      end

      def deactivate
        Ops::Developer::Disable.call(user: @user)
        redirect_to dashboard_users_url, flash: { success: "#{t('dashboard.users.notices.disabled')}: #{@user.email}" }
      end

      def add_role
        Ops::Developer::AssignRole.call(user: @user, role: params[:role])
        redirect_to dashboard_user_url(@user),
                    flash: { success: "#{params[:role].capitalize} #{t('dashboard.users.notices.add_role')}" }
      end

      def remove_role
        Ops::Developer::RemoveRole.call(user: @user, role: params[:role], size: @user.roles.size)
        redirect_to dashboard_user_url(@user),
                    flash: { success: "#{params[:role].capitalize} #{t('dashboard.users.notices.remove_role')}" }
      end

      private

      def authorize_role
        authorize :user, "#{action_name}?".to_sym
      end

      def user_find
        @user = User.find(params[:id])
      end

      def redirect_to_dashboard_user
        flash[:danger] = t('dashboard.users.alert.last_role')
        redirect_to dashboard_user_url(@user)
      end

      def user_params
        params.require(:user)
              .permit(:email, :first_name, :last_name, :location,
                    :timezone, :cv_url, :github)
      end
    end
  end
end
