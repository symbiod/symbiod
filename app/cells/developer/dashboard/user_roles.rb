# frozen_string_literal: true

module Developer
  module Dashboard
    # This cell renders user roles
    class UserRoles < BaseCell
      def link(role)
        authorize :user, :edit?
        model.roles_name.include?(role) ? unassign_link(role) : assign_link(role)
      end

      private

      def unassign_link(role)
        link_to t('dashboard.users.unassign_role', role: role), remove_role_dashboard_user_url(model, role: role),
                method: :put,
                data: { confirm: t('dashboard.users.confirm.unassign_role', role: role) }
      end

      def assign_link(role)
        link_to t('dashboard.users.assign_role', role: role), add_role_dashboard_user_url(model, role: role),
                method: :put,
                data: { confirm: t('dashboard.users.confirm.assign_role', role: role) }
      end
    end
  end
end
