# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Reject do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user, :screening_completed) }
    let(:feedback) { 'some feedback' }
    let!(:assignment) { create(:developer_test_task_assignment, developer: user) }
    let(:params) { { user: user, feedback: feedback } }

    it 'changes user state' do
      expect { subject.call(params) }
        .to change(user.reload, :state)
        .from('screening_completed').to('rejected')
    end

    it 'persist rejection feedback' do
      expect { subject.call(params) }
        .to change { assignment.reload.feedback }
        .from(nil).to(feedback)
    end

    it 'sends email about rejection with sidekiq-job' do
      expect(Sidekiq::Worker.jobs.to_s.include?('RejectionNotificationMailer')).to eq true
    end
  end
end
