# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Onboarding::SynchronizeGithubMembership do
  subject { described_class.call(user: user) }
  let!(:user) { create(:user, :developer, :active) }
  let!(:service) { double }
  before { allow(GithubService).to receive(:new).with(any_args).and_return(service) }

  context 'user status github invited' do
    before { create(:developer_onboarding, :invited_to_github, user: user) }

    it 'check users in team' do
      expect(service).to receive(:team_member?).with(user.github, Settings.github.default_team)
      subject
    end

    it 'user in the team and change status github to joined' do
      allow(service).to receive(:team_member?).with(any_args).and_return(true)
      expect { subject }.to change { user.developer_onboarding.github_status }
        .from('github_invited').to('github_joined')
    end

    it 'user is not in the team and not change status github' do
      allow(service).to receive(:team_member?).with(any_args).and_return(false)
      subject
      expect(user.developer_onboarding.reload.github_status).to eq 'github_invited'
    end
  end

  context 'user status github joined' do
    before { create(:developer_onboarding, :joined_to_github, user: user) }

    it 'check users in team' do
      expect(service).to receive(:team_member?).with(user.github, Settings.github.default_team)
      subject
    end

    it 'user in the team and not change status github' do
      allow(service).to receive(:team_member?).with(any_args).and_return(true)
      subject
      expect(user.developer_onboarding.reload.github_status).to eq 'github_joined'
    end

    it 'user is not in the team and change status github to left' do
      allow(service).to receive(:team_member?).with(any_args).and_return(false)
      expect { subject }.to change { user.developer_onboarding.github_status }
        .from('github_joined').to('github_left')
    end
  end
end
