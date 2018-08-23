# frozen_string_literal: true

module Ops
  module Developer
    class Onboarding
      # Here check members by organization GitHub
      class CheckInviteToGithub < ::Ops::Developer::BaseOperation
        step :check_membership!
        success :set_onboarding_to_github!

        private

        def check_membership!(_ctx, user:, **)
          GithubService
            .new(github_config.api_token, github_config.organization)
            .team_member?(user.github, github_config.default_team)
        end

        def set_onboarding_to_github!(_ctx, user:, **)
          user.developer_onboarding.update!(github: true)
        end
      end
    end
  end
end
