# frozen_string_literal: true

module Staff
  # Sends mail notify about completed of screening
  class ScreeningCompletedMailer < ApplicationMailer
    default to: -> { User.with_any_role(:staff, :mentor).pluck(:email) }

    def notify(user_id)
      @user = User.find(user_id)
      mail(subject: "#{t('bootcamp.screening.completed')}, #{@user.full_name}")
    end
  end
end
