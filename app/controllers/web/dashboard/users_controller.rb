# frozen_string_literal: true

module Web
  module Dashboard
    # Assigns the role to the user
    class UsersController < BaseController
      before_action :user_find, except: %i[index show]
      before_action do
        authorize_role(:user)
      end
      rescue_from Ops::Developer::UnassignRole::LastRoleError, with: :redirect_to_dashboard_user

      def index
        @users = User.newer_first.page params[:page]
      end

      def show
        @roles = Role.all
        @user = User.includes(:notes).find(params[:id])
        @test_task_assignments = @user.test_task_assignments.order(id: :asc)
      end

      def edit
        @skills = Skill.active.order(title: :asc)
      end

      def update
        result = Ops::Developer::UpdateProfile.call(
          user: @user,
          params: user_params
        )
        if result.success?
          redirect_to dashboard_user_url,
                      flash: { success: "#{t('dashboard.users.notices.update')}: #{@user.full_name}" }
        else
          render :edit
        end
      end

      def activate
        Ops::Developer::Activate.call(user: @user, performer: current_user.id)
        redirect_to dashboard_users_url,
                    flash: { success: "#{t('dashboard.users.notices.activated')}: #{@user.full_name}" }
      end

      def deactivate
        Ops::Developer::Disable.call(user: @user)
        redirect_to dashboard_users_url,
                    flash: { success: "#{t('dashboard.users.notices.disabled')}: #{@user.full_name}" }
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

      def user_find
        @user = User.find(params[:id])
      end

      def redirect_to_dashboard_user
        flash[:danger] = t('dashboard.users.alert.last_role')
        redirect_to dashboard_user_url(@user)
      end

      def user_params
        params.require(:user).permit(:email, :first_name, :last_name, :location,
                                     :timezone, :cv_url, :github, :primary_skill_id)
      end
    end
  end
end
