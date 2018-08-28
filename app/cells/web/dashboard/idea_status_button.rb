# frozen_string_literal: true

module Web
  module Dashboard
    # This cell renders status idea
    class IdeaStatusButton < BaseStatusButton
      private

      def link_status
        model.rejected? ? 'disabled' : ''
      end

      def url_status
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
