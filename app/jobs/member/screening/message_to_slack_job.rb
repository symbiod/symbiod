# frozen_string_literal: true

module Member
  module Screening
    # Runs send message to slack channel about screening completed.
    class MessageToSlackJob < ApplicationJob
      queue_as :default

      def perform(applicant_id)
        applicant = ::User.find(applicant_id)
        Ops::Member::Screening::MessageToSlack.call(applicant: applicant)
      end
    end
  end
end
