# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders user roles
    class UserRoles < BaseCell
      def render_role(role_name)
        return '' unless UserPolicy.new(current_user, nil).manage_roles?
        render_role_management(role_name)
      end

      private

      def render_role_management(role_name)
        model.roles_name.include?(role_name) ? role_status_button(role_name) : add_role(role_name)
      end

      def role_status_button(role_name)
        cell(Web::Dashboard::RoleStatusButton, Roles::RolesManager.new(model).role_for(role_name))
      end

      def add_role(role_name)
        link_to t('dashboard.users.assign_role', role: role_name),
                add_role_dashboard_user_url(model, role: role_name),
                method: :put,
                data: { confirm: t('dashboard.users.confirm.assign_role', role: role_name) }
      end

      def list_roles
        UserPolicy.new(current_user, nil).manage_roles? ? Roles::RolesManager.roles : model.roles_name
      end
    end
  end
end
