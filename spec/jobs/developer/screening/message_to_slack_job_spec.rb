# frozen_string_literal: true

require 'rails_helper'

describe ::Developer::Screening::MessageToSlackJob do
  describe '#perform' do
    let(:applicant) { create(:user, :developer, :screening_completed) }
    let(:applicant_id) { applicant.id }

    it 'calls InviteToSlack operation' do
      expect(Ops::Developer::Screening::MessageToSlack).to receive(:call).with(applicant: applicant)
      described_class.perform_now(applicant_id)
    end
  end
end
