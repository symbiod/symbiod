# frozen_string_literal: true

module Developer
  class Onboarding
    # Runs onboarding step in asyncronous manner.
    # Allows to retry if the step failure is caused by
    # bad HTTP call to 3rd party API endpoint.
    class SlackJob < ApplicationJob
      queue_as :default

      def perform(user_id)
        user = User.find(user_id)
        Ops::Developer::InviteToSlack.call(user: user)
      end
    end
  end
end
