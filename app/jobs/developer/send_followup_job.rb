# frozen_string_literal: true

require './app/models/developer/onboarding'
require './app/operations/ops/developer/uncompleted_users'

module Developer
  class SendFollowupJob < ApplicationJob
    queue_as :default

    def perform
      @users = Users::ScreeningUncompletedNotificationUsersQuery.new.call
      if @users.present?
        @users.each do |user|
          Ops::Developer::UncompletedUsers.call(user: user)
        end
      end
    end
  end
end
