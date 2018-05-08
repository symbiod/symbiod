# frozen_string_literal: true

module Staff
  # Sends mail to notify about completed of screening
  class ScreeningCompletedMailer < ApplicationMailer
    default to: -> { User.with_role(:staff).pluck(:email) }

    def notify(user)
      @user = user
      mail(subject: "#{t('bootcamp.screening.completed')}, #{user.name}")
    end
  end
end
