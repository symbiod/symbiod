# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Activate do
  subject { described_class }
  let(:performer) { create(:user, :staff) }
  let(:candidate) { create(:user, :developer, :screening_completed) }
  let(:params) { { user: candidate, performer: performer.id } }
  let(:role) { role_for(user: candidate, role_name: :developer) }

  describe '#call' do
    it 'changes candidates state' do
      expect { subject.call(params) }
        .to change { role.reload.state }
        .from('screening_completed').to('active')
    end

    it 'assigns an approver to the candidate' do
      expect { subject.call(params) }
        .to change { candidate.reload.approver_id }
        .from(nil).to(performer.id)
    end

    it 'sends onboarding notification' do
      expect { subject.call(params) }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with(
          'Developer::OnboardingStartedMailer',
          'notify',
          'deliver_now',
          candidate.id
        )
    end

    it 'starts onboarding' do
      expect(Ops::Developer::Onboarding).to receive(:call).with(user: candidate)
      subject.call(params)
    end
  end
end
