# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Activate do
  subject { described_class }
  let(:user) { create(:user, :staff) }
  let(:candidate) { create(:user, :screening_completed) }
  let(:params) { { user: candidate, performer: user.id } }

  describe '#call' do
    it 'changes candidates state' do
      expect { subject.call(params) }
        .to change { candidate.reload.state }
        .from('screening_completed').to('active')
    end

    it 'add approver to candidate' do
      expect { subject.call(params) }
        .to change { candidate.reload.approver_id }
        .from(nil).to(user.id)
    end

    it 'sends email about start of onboarding with sidekiq-job' do
      expect { subject.call(params) }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with(
          'Developer::OnboardingStartedMailer',
          'notify',
          'deliver_now',
          candidate.id
        )
    end

    it 'starts onboarding operation' do
      expect(Ops::Developer::Onboarding).to receive(:call).with(user: candidate)
      subject.call(params)
    end
  end
end
