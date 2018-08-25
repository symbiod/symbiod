# frozen_string_literal: true

module Ops
  module Member
    # This is master onboarding operation
    # It triggers different steps of onboarding
    # TODO: consider making a namespace 'Onboarding' and
    # possible creation of start/stop operations.
    class Onboarding < BaseOperation
      step :setup_onboarding
      step :invite_to_slack!
      step :invite_to_github!

      private

      def setup_onboarding(_ctx, user:, **)
        user.create_member_onboarding
      end

      def invite_to_slack!(_ctx, user:, **)
        ::Member::Onboarding::SlackJob.perform_later(user.id)
        true
      end

      def invite_to_github!(_ctx, user:, **)
        ::Member::Onboarding::GithubJob.perform_later(user.id)
        true
      end
    end
  end
end
