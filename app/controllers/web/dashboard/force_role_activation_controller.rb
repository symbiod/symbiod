# frozen_string_literal: true

module Web
  module Dashboard
    # Allows to force activate some role, without taking a look at its current state
    class ForceRoleActivationController < RoleActivationController
      before_action do
        ::Dashboard::RoleChangeStatePolicy.new(current_user, nil).force_activate?
      end

      def update
        Ops::Roles::ForceActivate.call(user: @role.user, performer: current_user)
        redirect_to dashboard_user_url(@role.user),
                    flash: { success: "#{t('dashboard.roles.notices.activated')}: #{@role.name}" }
      end
    end
  end
end
