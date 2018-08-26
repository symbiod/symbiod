# frozen_string_literal: true

module Member
  module Dashboard
    # This cell renders user roles
    class UserRoles < BaseCell
      def render_role(role)
        if UserPolicy.new(current_user, nil).manage_roles?
          link(role)
        else
          role
        end
      end

      private

      def link(role)
        model.roles_name.include?(role) ? unassign_link(role) : assign_link(role)
      end

      def unassign_link(role)
<<<<<<< HEAD:app/cells/member/dashboard/user_roles.rb
        cell(Member::Dashboard::UserStatusButton, Roles::RolesManager.new(model).role_for(role))
=======
        cell(Developer::Dashboard::RoleStatusButton, Roles::RolesManager.new(model).role_for(role))
>>>>>>> (#316) refactoring activation/deactivation buttons:app/cells/developer/dashboard/user_roles.rb
      end

      def assign_link(role)
        link_to t('dashboard.users.assign_role', role: role), add_role_dashboard_user_url(model, role: role),
                method: :put,
                data: { confirm: t('dashboard.users.confirm.assign_role', role: role) }
      end

      def list_roles
        UserPolicy.new(current_user, nil).manage_roles? ? Roles::RolesManager.roles : model.roles_name
      end
    end
  end
end
