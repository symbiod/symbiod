# frozen_string_literal: true

module Developer
  # Sends reminder for uncompleted screening
  class SendFollowupMailer < ApplicationMailer
    def notify(user_id)
      @user = User.find(user_id)
      @url = bootcamp_root_url
      # change subject!!!
      mail(to: @user.email, subject: 'Uncompleted screening')
    end
  end
end
