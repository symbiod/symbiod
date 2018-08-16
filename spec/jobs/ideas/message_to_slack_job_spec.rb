# frozen_string_literal: true

require 'rails_helper'

describe Ideas::MessageToSlackJob do
  describe '#perform' do
    let(:idea) { create(:idea) }
    let(:idea_id) { idea.id }

    it 'calls InviteToSlack operation' do
      expect(Ops::Idea::MessageToSlack).to receive(:call).with(idea: idea)
      described_class.perform_now(idea_id)
    end
  end
end
