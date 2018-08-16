# frozen_string_literal: true

module Developer
  module Dashboard
    # This cell renders status user
    class UserStatusButton < BaseCell
      STATE_DISABLED_BUTTON = %w[pending profile_completed rejected policy_accepted screening_completed].freeze

      def role_status
        policy(:user).activate? ? user_state : model.state
      end

      private

      def user_state
        link_to model.state, change_state,
                method: :put,
                class: "btn btn-#{color_status} btn-sm#{button_state}",
                data: { confirm: t("dashboard.users.link.confirm.#{confirm_status}") }
      end

      def color_status
        model.active? ? 'success' : color_not_success_status
      end

      def color_not_success_status
        return 'danger' if model.is?(:staff)
        model.pending? ? 'warning' : 'danger'
      end

      def button_state
        STATE_DISABLED_BUTTON.include?(model.state) ? ' disabled' : ''
      end

      def confirm_status
        model.active? ? 'disable' : 'activate'
      end

      def change_state
        model.active? ? dashboard_role_deactivation_url(model) : dashboard_role_activation_url(model)
      end
    end
  end
end
