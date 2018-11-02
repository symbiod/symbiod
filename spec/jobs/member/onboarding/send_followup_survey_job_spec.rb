# frozen_string_literal: true

require 'rails_helper'

describe Member::Onboarding::SendFollowupSurveyJob do
  subject { described_class }
  let(:role) { create(:role) }
  before { role.user.create_member_onboarding }

  describe '#perform' do
    it 'calls Member::Onboarding::SendSurveyFollowup operation' do
      expect(Ops::Member::Onboarding::SendSurveyFollowup).to receive(:call).with(role: role)
      subject.perform_now
    end
  end
end
