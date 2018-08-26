# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Reject do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user, :member, :screening_completed) }
    let(:feedback) { 'some feedback' }
    let!(:assignment) { create(:member_test_task_assignment, member: user) }
    let(:params) { { user: user, feedback: feedback } }
    let(:role) { role_for(user: user, role_name: :member) }

    it 'changes role state' do
      expect { subject.call(params) }
        .to change { role.reload.state }
        .from('screening_completed').to('rejected')
    end

    it 'persist rejection feedback' do
      expect { subject.call(params) }
        .to change { assignment.reload.feedback }
        .from(nil).to(feedback)
    end

    it 'sends email about rejection' do
      expect { subject.call(params) }
        .to have_enqueued_job(ActionMailer::DeliveryJob)
        .with(
          'Member::RejectionNotificationMailer',
          'notify',
          'deliver_now',
          user.id,
          feedback
        )
    end
  end
end
