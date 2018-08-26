# frozen_string_literal: true

require 'rails_helper'

describe Member::Onboarding::GithubJob do
  describe '#perform' do
    let(:user) { create(:user) }

    it 'calls InviteToGithub operation' do
      expect(Ops::Member::InviteToGithub).to receive(:call).with(user: user)
      described_class.perform_now(user.id)
    end
  end
end
