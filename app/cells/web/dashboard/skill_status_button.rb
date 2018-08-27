# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status idea
    class SkillStatusButton < BaseStatusButton
      private

      def url_status
        model.active? ? deactivate_dashboard_skill_url(model) : activate_dashboard_skill_url(model)
      end
    end
  end
end
