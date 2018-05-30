# frozen_string_literal: true

module Mentor
  # Sends mail notify to mentor about completed of screening
  class ScreeningCompletedMailer < ApplicationMailer
    default to: -> { User.with_role(:mentor).pluck(:email) }

    def notify(user_id)
      @user = User.find(user_id)
      mail(subject: "#{t('bootcamp.screening.completed')}, #{@user.full_name}")
    end
  end
end
