# frozen_string_literal: true

require 'rails_helper'

describe Developer::Onboarding::SynchronizeSlackMembershipsJob do
  subject { described_class }
  let!(:user) { create(:user, :developer, :active) }
  before { create(:developer_onboarding, :invited_to_slack, user: user) }

  describe '#parform' do
    it 'calls users query' do
      expect(::Onboarding::UsersInvitedAndJoinedSlackQuery)
        .to receive(:call).and_return([user])
      allow(::Ops::Developer::Onboarding::SynchronizeSlackMembership)
        .to receive(:call).with(user: user)
      subject.perform_now
    end

    it 'calls synchronize users slack' do
      allow(::Onboarding::UsersInvitedAndJoinedSlackQuery)
        .to receive(:call).and_return([user])
      expect(::Ops::Developer::Onboarding::SynchronizeSlackMembership)
        .to receive(:call).with(user: user)
      subject.perform_now
    end
  end
end
