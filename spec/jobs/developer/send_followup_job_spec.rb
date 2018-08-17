# frozen_string_literal: true

require 'rails_helper'

describe Developer::SendFollowupJob do
  describe '#perform' do
    let(:user) { create(:user, :developer, :pending) }

    it 'calls InviteToSlack operation' do
      expect(Ops::Developer::SendScreeningFollowup).to receive(:call).with(user: user)
      described_class.perform_now
    end
  end
end
