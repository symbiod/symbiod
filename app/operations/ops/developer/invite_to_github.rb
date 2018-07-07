# frozen_string_literal: true

module Ops
  module Developer
    # Handles all business logic regarding adding new member to GitHub.
    # Besides calling public API, it also markes onboarding step as completed.
    class InviteToGithub < BaseOperation
      step :add_to_github!
      # TODO: makes sense to extract to base class for all onboarding steps
      step :mark_step_as_complete!

      def add_to_github!(_ctx, user:, **)
        GithubService
          .new(github_config.api_token, github_config.organization)
          .invite_member(user.github_uid, github_config.default_team)
        true
      end

      def mark_step_as_complete!(_ctx, user:, **)
        # TODO: consider introducing specific fields for onboarding status
        # like:
        # - invited_to_github
        # - accepted_github_invitation
        # - left_github
        user.developer_onboarding.update!(github: true)
      end

      private

      def github_config
        Settings.github
      end
    end
  end
end
