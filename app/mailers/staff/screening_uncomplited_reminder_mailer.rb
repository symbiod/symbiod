# frozen_string_literal: true

module Staff
  # Sends reminder for uncompleted screening
  class Staff::ScreeningUncomplitedReminderMailer < ApplicationMailer
    def notify(user)
      @user = user
      @url = bootcamp_root_url
      # change subject!!!
      mail(to: @user.email, subject: 'Uncompleted screening')
    end
  end
end