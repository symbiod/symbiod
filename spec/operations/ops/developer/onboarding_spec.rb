# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Onboarding do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user) }
    let(:params) { { user: user } }

    it 'creates_onboarding' do
      expect { subject.call(params) }.to change(Developer::Onboarding, :count).by(1)
    end

    it 'assigns onboarding to user' do
      expect { subject.call(params) }
        .to change(user.reload, :developer_onboarding)
        .from(nil)
    end

    it 'sends invitation to Slack' do
      expect(::Developer::Onboarding::SlackJob)
        .to receive(:perform_later)
        .with(user.id)
      subject.call(params)
    end

    it 'sends invitation to Github' do
      expect(::Developer::Onboarding::GithubJob)
        .to receive(:perform_later)
        .with(user.id)
      subject.call(params)
    end
  end
end
