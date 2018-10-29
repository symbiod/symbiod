# frozen_string_literal: true

require 'rails_helper'

describe Member::Onboarding::SendFollowupSurveyJob do
  subject { described_class }
  let!(:user) { create(:user, :member, :active) }
  let!(:role) { create(:role, user: user) }
  before { create(:member_onboarding, user: user) }

  describe '#perform' do
    it 'calls Member::Onboarding::SendSurveyFollowup operation' do
      expect(Ops::Member::Onboarding::SendSurveyFollowup).to receive(:call).with(role: role)
      described_class.perform_now
    end
  end
end
