# frozen_string_literal: true

module Ops
  module Developer
    # Handles all business logic regarding adding new member to GitHub.
    # Besides calling public API, it also markes onboarding step as completed.
    class InviteToGithub < BaseOperation
      success :add_to_github!

      def add_to_github!(_ctx, user:, **)
        GithubService
          .new(github_config.api_token, github_config.organization)
          .invite_member(user.github_uid, github_config.default_team)
      end
    end
  end
end
