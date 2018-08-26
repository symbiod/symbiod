# frozen_string_literal: true

module Ops
  module Member
    # Handles all business logic regarding adding new member to GitHub.
    # Besides calling public API, it also markes onboarding step as completed.
    class InviteToGithub < BaseOperation
      success :add_to_github!
      step :mark_step_as_invited!

      private

      def add_to_github!(_ctx, user:, **)
        GithubService
          .new(github_config.api_token, github_config.organization)
          .invite_member(user.github_uid, github_config.default_team)
      end

      def mark_step_as_invited!(_ctx, user:, **)
        user.member_onboarding.github_invite!
      end
    end
  end
end
