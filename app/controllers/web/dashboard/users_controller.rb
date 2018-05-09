# frozen_string_literal: true

module Web
  module Dashboard
    # Users management logic
    class UsersController < BaseController
      before_action :user_find, except: :index
      before_action :authorize_staff!
      rescue_from Pundit::NotAuthorizedError, with: :redirect_to_dashboard_users

      def index
        @users = User.active_disabled
      end

      def show
        @roles = Role.all
      end

      def activate
        Ops::Developer::Activate.call(user: @user)
        redirect_to dashboard_users_path,
                    flash: { success: "#{t('dashboard.users.notices.activated')}: #{@user.email}" }
      end

      def disable
        Ops::Developer::Disable.call(user: @user)
        redirect_to dashboard_users_path, flash: { success: "#{t('dashboard.users.notices.disabled')}: #{@user.email}" }
      end

      def add_role
        Ops::Developer::AddRole.call(user: @user, role: params[:role])
        redirect_to dashboard_user_path(@user),
                    flash: { success: "#{params[:role]} #{t('dashboard.users.notices.add_role')}" }
      end

      def remove_role
        Ops::Developer::RemoveRole.call(user: @user, role: params[:role], size: @user.roles.size)
        redirect_to dashboard_user_path(@user)
      end

      private

      def authorize_staff!
        authorize :user, "#{action_name}?".to_sym
      end

      def user_find
        @user = User.find(params[:id])
      end
    end
  end
end
