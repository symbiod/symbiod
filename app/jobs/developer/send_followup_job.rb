# frozen_string_literal: true

require './app/models/developer/onboarding'
require './app/operations/ops/developer/invite_to_github'

module Developer
  class SendFollowupJob < ApplicationJob
    queue_as :mailers

    def perform(user_id)
      @user = User.find(user_id)
      Developer::SendFollowupMailer.notify(@user.id).deliver_later
    end
  end
end
