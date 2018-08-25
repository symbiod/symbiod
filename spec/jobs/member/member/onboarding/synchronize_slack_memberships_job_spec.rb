# frozen_string_literal: true

require 'rails_helper'

describe Member::Onboarding::SynchronizeSlackMembershipsJob do
  subject { described_class }
  let!(:user) { create(:user, :member, :active) }
  before { create(:member_onboarding, :invited_to_slack, user: user) }

  describe '#parform' do
    it 'calls users query' do
      expect(::Onboarding::UsersInvitedAndJoinedSlackQuery)
        .to receive(:call).and_return([user])
      allow(::Ops::Member::Onboarding::SynchronizeSlackMembership)
        .to receive(:call).with(user: user)
      subject.perform_now
    end

    it 'calls synchronize users slack' do
      allow(::Onboarding::UsersInvitedAndJoinedSlackQuery)
        .to receive(:call).and_return([user])
      expect(::Ops::Member::Onboarding::SynchronizeSlackMembership)
        .to receive(:call).with(user: user)
      subject.perform_now
    end
  end
end
