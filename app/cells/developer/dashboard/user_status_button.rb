# frozen_string_literal: true

module Developer
  module Dashboard
    # This cell renders status user
    class UserStatusButton < BaseCell
      def user_status
        current_user.has_role?(:staff) ? user_state : model.state
      end

      private

      def user_state
        link_to model.state, change_state,
                method: :put,
                class: "btn btn-#{color_status} btn-sm",
                data: { confirm: t("dashboard.users.link.confirm.#{confirm_status}") }
      end

      def color_status
        model.active? ? 'success' : color_not_success_status
      end

      def color_not_success_status
        model.pending? ? 'warning' : 'danger'
      end

      def confirm_status
        model.active? ? 'disable' : 'activate'
      end

      def change_state
        model.active? ? deactivate_dashboard_user_url(model) : activate_dashboard_user_url(model)
      end
    end
  end
end
