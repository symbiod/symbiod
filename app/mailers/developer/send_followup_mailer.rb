# frozen_string_literal: true

module Developer
  # Sends reminder for uncompleted screening
  class SendFollowupMailer < ApplicationMailer
    def notify(user_id)
      @user = User.find(user_id)
      mail(to: @user.email, subject: t('dashboard.users.mailers.uncompleted.subject'))
    end
  end
end
