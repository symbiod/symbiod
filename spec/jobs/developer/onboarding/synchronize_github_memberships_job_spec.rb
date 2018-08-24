# frozen_string_literal: true

require 'rails_helper'

describe Developer::Onboarding::SynchronizeGithubMembershipsJob do
  subject { described_class }
  let!(:user) { create(:user, :developer, :active) }
  before { create(:developer_onboarding, :invited_to_github, user: user) }

  describe '#parform' do
    it 'calls users query' do
      expect(::Onboarding::UsersInvitedAndJoinedGithubQuery).to receive(:call)
      subject.perform_now
    end

    it 'calls synchronize users github' do
      expect(::Ops::Developer::Onboarding::SynchronizeGithubMembership)
        .to receive(:call).with(user: user)
      subject.perform_now
    end
  end
end
