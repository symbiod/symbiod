require './app/operations/ops/developer/invite_to_github'

module Developer
  class Onboarding
    class GithubJob < ApplicationJob
      queue_as :default

      def perform(user_id)
        user = User.find(user_id)
        ::Ops::Developer::InviteToGithub.call(user: user)
      end
    end
  end
end
