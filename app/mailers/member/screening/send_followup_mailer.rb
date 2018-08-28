# frozen_string_literal: true
# TODO: remove namespace

module Member
  module Screening
    # Sends reminder for uncompleted screening
    class SendFollowupMailer < ApplicationMailer
      def notify(role_id)
        @role = Role.find(role_id)
        @role_name = Roles::RolesManager.role_name_by_type(@role.type) # "member"
        mail(to: @role.user.email, subject: t('dashboard.users.mailers.uncompleted.subject'))
      end
    end
  end
end
