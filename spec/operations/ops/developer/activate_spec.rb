# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Activate do
  subject { described_class }
  let(:user) { create(:user, :screening_completed) }
  let(:params) { { user: user } }

  describe '#call' do
    it 'changes users state' do
      expect { subject.call(params) }
        .to change { user.reload.state }
        .from('screening_completed').to('active')
    end

    it 'sends email about start of onboarding with sidekiq-job' do
      expect(Sidekiq::Worker.jobs.to_s.include?('OnboardingStartedMailer')).to eq true
    end

    it 'starts onboarding operation' do
      expect(Ops::Developer::Onboarding).to receive(:call).with(user: user)
      subject.call(params)
    end
  end
end
