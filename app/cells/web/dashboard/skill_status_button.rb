# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status idea
    class SkillStatusButton < BaseCell
      def skill_status
        link_to model.state,
                change_state,
                method: :put,
                class: "btn btn-#{color_status} btn-sm",
                data: { confirm: t("dashboard.ideas.confirm.#{confirm_status}") }
      end

      private

      def color_status
        model.active? ? 'success' : 'danger'
      end

      def confirm_status
        model.active? ? 'disable' : 'activate'
      end

      def change_state
        model.active? ? deactivate_dashboard_skill_url(model) : activate_dashboard_skill_url(model)
      end
    end
  end
end
