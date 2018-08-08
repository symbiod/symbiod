# frozen_string_literal: true

module Ops
  module Idea
    # This operation transits the idea from pending to voting state.
    # In other words the idea gets approved, so everyone can vote for it.
    # Author becomes active too, unless he was activated before during the
    # approve of some other idea.
    class StartVoting < BaseOperation
      step :change_state!
      step :activate_idea_author!
      # TODO: here we need to send message to common channel
      # with developers, who can vote for ideas.

      private

      def change_state!(_ctx, idea:, **)
        idea.voting!
      end

      def activate_idea_author!(_ctx, idea:, **)
        # TODO: rewrite with a author relation directly to the role
        author = idea.author.roles.find_by(type: 'Roles::Author')
        return true unless author.policy_accepted?
        Ops::Author::Activate.call(author: author)
      end
    end
  end
end
