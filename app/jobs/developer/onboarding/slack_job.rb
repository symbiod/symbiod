module Developer
  class Onboarding
    class SlackJob < ApplicationJob
      queue_as :default

      def perform(user_id)
        user = User.find(user_id)
        Ops::Developer::InviteToSlack.call(user: user)
      end
    end
  end
end
