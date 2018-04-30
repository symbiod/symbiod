module Ops
  module Developer
    class Onboarding < BaseOperation
      step :setup_onboarding
      step :invite_to_slack!
      step :invite_to_github!

      private

      def setup_onboarding(ctx, user:, **)
        user.create_developer_onboarding
      end

      def invite_to_slack!(ctx, user:, **)
        ::Developer::Onboarding::SlackJob.perform_later(user.id)
        true
      end

      def invite_to_github!(ctx, user:, **)
        ::Developer::Onboarding::GithubJob.perform_later(user.id)
        true
      end
    end
  end
end
