require 'rails_helper'

describe Ops::Roles::ForceActivate do
  describe '.call' do
    let(:parameters) { { user: user, performer: performer } }
    let(:user) { create(:user, :member, :pending) }
    let(:performer) { create(:user, :staff) }
    subject { described_class.call(parameters) }

    it 'changes state' do
      expect { subject }.to change{ user.roles.last.state }
        .from('pending')
        .to('active')
    end

    it 'sets approver' do
      expect { subject }.to change{ user.reload.approver_id }
        .from(nil)
        .to(performer.id)
    end

    it 'sends notification' do
      expect { subject }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with(
          'Member::OnboardingStartedMailer',
          'notify',
          'deliver_now',
          user.id
        )
    end

    it 'starts onboarding' do
      expect(Ops::Member::Onboarding).to receive(:call).with(user: user)
      subject
    end
  end
end
