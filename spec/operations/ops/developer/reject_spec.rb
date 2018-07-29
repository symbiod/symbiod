# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Reject do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user, :developer, :screening_completed) }
    let(:feedback) { 'some feedback' }
    let!(:assignment) { create(:developer_test_task_assignment, developer: user) }
    let(:params) { { user: user, feedback: feedback } }
    let(:role) { role_for(user: user, role_name: :developer) }

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
          'Developer::RejectionNotificationMailer',
          'notify',
          'deliver_now',
          user.id,
          feedback
        )
    end
  end
end
