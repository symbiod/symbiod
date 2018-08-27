# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status user
    class RoleStatusButton < BaseStatusButton
      private

      def url_status
        model.active? ? dashboard_role_deactivation_url(model) : dashboard_role_activation_url(model)
      end
    end
  end
end
