# frozen_string_literal: true

require 'rails_helper'

describe Member::Onboarding::SendFollowupSurveyJob do
  subject { described_class }
  let!(:user) { create(:user, :member, :active) }
  before { create(:member_onboarding, user: user) }
  before { create(:role, user: user) }

  describe '#perform' do
    it 'calls Member::Onboarding::SendSurveyFollowup operation' do
      expect(Ops::Member::Onboarding::SendSurveyFollowup).to receive(:call)
      described_class.perform_now
    end
  end
end
