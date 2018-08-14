# frozen_string_literal: true

require './app/models/developer/onboarding'
require './app/operations/ops/developer/invite_to_github'

module Developer
  class SendFollowupJob < ApplicationJob
    queue_as :default

    def perform()
      @users = Users::ScreeningUncompletedNotificationUsersQuery.new.call
      @users.each do |user|
        Developer::SendFollowupMailer.notify(user.id).deliver_later
      end
    end
  end
end
