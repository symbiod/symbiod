# frozen_string_literal: true

require 'rails_helper'

describe SlackMessageJob do
  describe '#perform' do
    let(:model) { create(:idea) }
    let(:channel) { 'ideas' }

    it 'calls InviteToSlack operation' do
      expect(Ops::Idea::MessageToSlack).to receive(:call).with(model: model, channel: channel)
      described_class.perform_now(model, channel)
    end
  end
end
