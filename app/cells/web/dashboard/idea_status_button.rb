# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status idea
    class IdeaStatusButton < BaseCell
      def idea_status
        policy(%i[dashboard idea]).activate? ? idea_state : model.state
      end

      private

      def idea_state
        link_to model.state,
                change_state,
                method: :put,
                class: "btn btn-#{color_status} btn-sm#{button_state}",
                data: { confirm: t("dashboard.ideas.confirm.#{confirm_status}") }
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

      def button_state
        model.rejected? ? ' disabled' : ''
      end

      def change_state
        model.active? ? deactivate_dashboard_idea_url(model) : activate_dashboard_idea_url(model)
      end
    end
  end
end
