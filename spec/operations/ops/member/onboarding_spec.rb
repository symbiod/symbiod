# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Onboarding do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user) }
    let(:params) { { user: user } }

    it 'creates_onboarding' do
      expect { subject.call(params) }.to change(Member::Onboarding, :count).by(1)
    end

    it 'assigns onboarding to user' do
      expect { subject.call(params) }
        .to change(user.reload, :member_onboarding)
        .from(nil)
    end

    it 'sends invitation to Slack' do
      expect(::Member::Onboarding::SlackJob)
        .to receive(:perform_later)
        .with(user.id)
      subject.call(params)
    end

    it 'sends invitation to Github' do
      expect(::Member::Onboarding::GithubJob)
        .to receive(:perform_later)
        .with(user.id)
      subject.call(params)
    end
  end
end
