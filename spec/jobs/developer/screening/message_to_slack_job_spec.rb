# frozen_string_literal: true

require 'rails_helper'

describe ::Member::Screening::MessageToSlackJob do
  describe '#perform' do
    let(:applicant) { create(:user, :member, :screening_completed) }
    let(:applicant_id) { applicant.id }

    it 'calls InviteToSlack operation' do
      expect(Ops::Member::Screening::MessageToSlack).to receive(:call).with(applicant: applicant)
      described_class.perform_now(applicant_id)
    end
  end
end
