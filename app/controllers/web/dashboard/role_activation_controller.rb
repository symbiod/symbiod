# frozen_string_literal: true

module Web
  module Dashboard
    # This class activates roles
    class RoleActivationController < BaseController
      before_action :role_find, only: :update
      before_action do
        authorize_role(%i[dashboard role_change_state])
      end

      def update
        Ops::Roles::Activate.call(role: @role)
        redirect_to dashboard_user_url(@role.user),
                    flash: { success: "#{t('dashboard.roles.notices.activated')}: #{@role.name}" }
      end

      private

      def role_find
        @role = Role.find(params[:id])
      end
    end
  end
end
