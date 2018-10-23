# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Onboarding::SendSurveyFollowup do
  subject { described_class.call(role: role) }
  let!(:role) { create(:role, :member, :active, :registered_3_days_ago) }
  before { role.user.create_member_onboarding }

  it 'sends email to users with uncomplete survey' do
    expect { subject }
      .to have_enqueued_job(ActionMailer::DeliveryJob)
      .with('Member::UnfinishedSurveyMailer', 'notify', 'deliver_now', role.id)
  end

  it 'updates followup counter' do
    expect { subject }
      .to change { role.reload.unfinished_survey_followup_counter }.by(1)
  end

  it 'updates last followup date' do
    expect { subject }
      .to change { role.reload.last_not_finished_survey_followup_date_at }
  end
end
