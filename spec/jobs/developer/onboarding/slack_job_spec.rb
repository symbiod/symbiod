# frozen_string_literal: true

require 'rails_helper'

describe Developer::Onboarding::SlackJob do
  describe '#perform' do
    let(:user) { create(:user) }

    it 'calls InviteToSlack operation' do
      expect(Ops::Developer::InviteToSlack).to receive(:call).with(user: user)
      described_class.perform_now(user.id)
    end
  end
end
