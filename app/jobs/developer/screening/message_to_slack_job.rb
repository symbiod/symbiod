# frozen_string_literal: true

module Developer
  module Screening
    # Runs send message to slack channel about screening completed.
    class MessageToSlackJob < ApplicationJob
      queue_as :default

      def perform(applicant_id)
        applicant = ::User.find(applicant_id)
        Ops::Developer::Screening::MessageToSlack.call(applicant: applicant)
      end
    end
  end
end
