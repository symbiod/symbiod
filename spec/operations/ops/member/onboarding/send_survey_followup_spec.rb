# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Onboarding::SendSurveyFollowup do
  subject { described_class }

  describe '#call' do
    let!(:role) { create(:role, :member, :active, :registered_3_days_ago) }

    it 'sends email to users with uncomplete survey' do
      # binding.pry
      expect { subject.call }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with('Member::UnfinishedSurveyMailer', 'notify', 'deliver_later', role.id)
    end

    it 'updates followup conter' do
      # binding.pry
      role.reload
      expect { subject.call }
        .to change { role.unfinished_survey_followup_counter }.by(1)
    end

    it 'updates last followup date' do
      # binding.pry
      role.reload
      expect { subject }
        .to change { role.last_unfinished_survey_followup_date }
    end
  end
end
