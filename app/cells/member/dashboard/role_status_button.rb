# frozen_string_literal: true

module Member
  module Dashboard
    # This cell renders status user
    class RoleStatusButton < BaseStatusButton
      def role_status
        policy(:user).activate? ? link_to_status : model.state
      end

      private

      def url_status
        model.active? ? dashboard_role_deactivation_url(model) : dashboard_role_activation_url(model)
      end
    end
  end
end
