# frozen_string_literal: true

module Ops
  module Screening
    # Notifies about uncompleted steps
    class SendScreeningFollowup < BaseOperation
      step :screening_uncompleted_notification!

      private

      def screening_uncompleted_notification!(_ctx, **)
        roles = ::Roles::Screening::UncompletedRolesQuery.new.call

        roles.each do |role|
          ::Screening::SendFollowupMailer.notify(role.id).deliver_later
          role.user.set_last_screening_followup_date
        end
      end
    end
  end
end
