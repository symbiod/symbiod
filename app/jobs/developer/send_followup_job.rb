# frozen_string_literal: true

require './app/models/developer/onboarding'
require './app/operations/ops/developer/invite_to_github'

module Developer
  class SendFollowupJob < ApplicationJob
    queue_as :default

    def perform()
      @users = Users::ScreeningUncompletedNotificationUsersQuery.new.call
      if @users
        @users.each do |user|
          Ops::Developer::UncompletedUsers.call(user: User.first)
        end
      end
    end
  end
end
