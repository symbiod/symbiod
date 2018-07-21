# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status idea
    class IdeaStatusButton < BaseCell
      def idea_status
        link_to button_name,
                change_state,
                method: :put,
                class: "btn btn-#{color_status} btn-sm#{button_status}",
                data: { confirm: t("dashboard.ideas.confirm.#{confirm_status}") }
      end

      private

      def button_status
        model.rejected? ? ' disabled' : ''
      end

      def button_name
        if model.pending?
          t('dashboard.ideas.button.voting')
        elsif model.active?
          t('dashboard.ideas.button.disable')
        else
          t('dashboard.ideas.button.activate')
        end
      end

      def color_status
        if model.active?
          'danger'
        elsif model.pending?
          'warning'
        else
          'success'
        end
      end

      def confirm_status
        if model.pending?
          'voting'
        elsif model.active?
          'disable'
        else
          'active'
        end
      end

      def change_state
        if model.pending?
          voting_dashboard_idea_url(model)
        elsif model.active?
          deactivate_dashboard_idea_url(model)
        else
          activate_dashboard_idea_url(model)
        end
      end
    end
  end
end
