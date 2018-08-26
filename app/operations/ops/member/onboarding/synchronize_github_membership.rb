# frozen_string_literal: true

module Ops
  module Member
    class Onboarding
      # Here check members by organization GitHub
      class SynchronizeGithubMembership < ::Ops::Member::BaseOperation
        step :check_membership!
        failure :mark_step_as_left!
        success :mark_step_as_joined!

        private

        def check_membership!(_ctx, user:, **)
          GithubService
            .new(github_config.api_token, github_config.organization)
            .team_member?(user.github, github_config.default_team)
        end

        def mark_step_as_left!(_ctx, user:, **)
          user.member_onboarding.github_left! if user.member_onboarding.github_joined?
        end

        def mark_step_as_joined!(_ctx, user:, **)
          user.member_onboarding.github_join! if user.member_onboarding.github_invited?
        end
      end
    end
  end
end
