# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Screening::SendScreeningFollowup do
  subject { described_class }

  describe '#call' do
    let!(:role) { create(:role, :member, :pending) }

    it 'sends email to uncompleted users' do
      expect { subject.call() }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with('Member::Screening::SendFollowupMailer', 'notify', 'deliver_now', role.id)
    end

    it 'updates last followup date' do
      expect { subject.call() }
        .to change { role.user.reload.last_screening_followup_date }
    end
  end
end
