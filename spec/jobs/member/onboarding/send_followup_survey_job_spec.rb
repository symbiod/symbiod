# frozen_string_literal: true

require 'rails_helper'

describe Member::Onboarding::SendFollowupSurveyJob do
  subject { described_class }
  let(:role) { create(:role) }
  before { role.user.create_member_onboarding }

  describe '#perform' do
    it 'calls roles query' do
      expect(::Onboarding::RolesInvitedAndNotFinishedSurveyQuery)
        .to receive(:call).and_return([role])
      allow(Ops::Member::Onboarding::SendSurveyFollowup)
        .to receive(:call).with(role: role)
      subject.perform_now
    end

    it 'calls Member::Onboarding::SendSurveyFollowup operation' do
      allow(::Onboarding::RolesInvitedAndNotFinishedSurveyQuery)
        .to receive(:call).and_return([role])
      expect(Ops::Member::Onboarding::SendSurveyFollowup)
        .to receive(:call).with(role: role)
      subject.perform_now
    end
  end
end
