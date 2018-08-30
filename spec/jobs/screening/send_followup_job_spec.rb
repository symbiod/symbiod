# frozen_string_literal: true

require 'rails_helper'

describe Screening::SendFollowupJob do
  describe '#perform' do
    let(:project) { create(:project) }

    it 'calls Projects::Kickoff operation' do
      expect(Ops::Screening::SendScreeningFollowup).to receive(:call)
      described_class.perform_now
    end
  end
end
