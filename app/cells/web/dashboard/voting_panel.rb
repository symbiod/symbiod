# frozen_string_literal: true

module Web
  module Dashboard
    # This cell rendring voting panel
    class VotingPanel < BaseStatusButton
      def render_vote_action(vote)
        if ::Dashboard::VotePolicy.new(current_user, model).up?
          link_to_status status: vote, url: url_status(vote)
        else
          content_tag :i,
                      nil,
                      class: "fa fa-arrow-#{vote}",
                      style: "color: #{style_color(vote)}"
        end
      end

      private

      def url_status(vote)
        public_send("#{vote}_dashboard_idea_vote_url", model, id: model.id)
      end

      def style_color(vote)
        COLOR_STATUS["#{vote}_arrow".to_sym]
      end
    end
  end
end
