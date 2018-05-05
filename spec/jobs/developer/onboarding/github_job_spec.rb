# frozen_string_literal: true

require 'rails_helper'

describe Developer::Onboarding::GithubJob do
  describe '#perform' do
    let(:user) { create(:user) }

    it 'calls InviteToGithub operation' do
      expect(Ops::Developer::InviteToGithub).to receive(:call).with(user: user)
      described_class.perform_now(user.id)
    end
  end
end
