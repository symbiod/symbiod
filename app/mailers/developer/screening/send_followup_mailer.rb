# frozen_string_literal: true

module Developer
  module Screening
    # Sends reminder for uncompleted screening
    class SendFollowupMailer < ApplicationMailer
      def notify(user_id)
        @user = User.find(user_id)
        @mail = mail(to: @user.email, subject: t('dashboard.users.mailers.uncompleted.subject'))
        @user.update_attribute(:last_screening_followup_date, @mail.date)
      end
    end
  end
end
