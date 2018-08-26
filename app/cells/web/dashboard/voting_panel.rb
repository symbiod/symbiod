# frozen_string_literal: true

module Web
  module Dashboard
    # This cell rendring voting panel
    class VotingPanel < BaseLinkStatusButton
      def render_vote_action(vote)
        if ::Dashboard::VotePolicy.new(current_user, model).up?
          link_to_status name: vote,
                         url: url_status(vote),
                         color: color_status(vote),
                         confirm: confirm_status(vote)
        else
          vote
        end
      end

      private

      def url_status(vote)
        public_send("#{vote}_dashboard_idea_vote_url", model, id: model.id)
      end

      def color_status(vote)
        COLOR_STATUS[vote.to_sym]
      end

      def confirm_status(vote)
        CONFIRM_STATUS[vote.to_sym]
      end
    end
  end
end
