# frozen_string_literal: true

require 'rails_helper'

describe Member::Onboarding::SynchronizeGithubMembershipsJob do
  subject { described_class }
  let!(:user) { create(:user, :member, :active) }
  before { create(:member_onboarding, :invited_to_github, user: user) }

  describe '#parform' do
    it 'calls users query' do
      expect(::Onboarding::UsersInvitedAndJoinedGithubQuery)
        .to receive(:call).and_return([user])
      allow(::Ops::Member::Onboarding::SynchronizeGithubMembership)
        .to receive(:call).with(user: user)
      subject.perform_now
    end

    it 'calls synchronize users github' do
      allow(::Onboarding::UsersInvitedAndJoinedGithubQuery)
        .to receive(:call).and_return([user])
      expect(::Ops::Member::Onboarding::SynchronizeGithubMembership)
        .to receive(:call).with(user: user)
      subject.perform_now
    end
  end
end
