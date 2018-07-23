# frozen_string_literal: true

module Web
  module Dashboard
    # This cell rendring voting panel
    class VotingPanel < BaseCell
      COLOR_BUTTON = { up: 'success', down: 'danger' }.freeze

      def render_vote_action(vote)
        if ::Dashboard::VotePolicy.new(current_user, model).up?
          voting_link(vote)
        else
          vote
        end
      end

      private

      def voting_link(vote)
        link_to vote,
                public_send("#{vote}_dashboard_idea_vote_url", model, id: model.id),
                method: :put,
                class: "btn btn-#{COLOR_BUTTON[vote.to_sym]} btn-sm"
      end
    end
  end
end
