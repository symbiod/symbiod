# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Onboarding::SynchronizeSlackMembership do
  subject { described_class.call(user: user) }
  let!(:user) { create(:user, :developer, :active) }
  let!(:service) { double }
  before { allow(SlackService).to receive(:new).with(any_args).and_return(service) }

  context 'user status slack invited' do
    before { create(:developer_onboarding, :invited_to_slack, user: user) }

    it 'check users in team' do
      expect(service).to receive(:team_member?).with(user.email)
      subject
    end

    it 'user in the team and change status slack to joined' do
      allow(service).to receive(:team_member?).with(any_args).and_return(true)
      expect { subject }.to change { user.developer_onboarding.slack_status }
        .from('slack_invited').to('slack_joined')
    end

    it 'user is not in the team and not change status slack' do
      allow(service).to receive(:team_member?).with(any_args).and_return(false)
      subject
      expect(user.developer_onboarding.reload.slack_status).to eq 'slack_invited'
    end
  end

  context 'user status slack joined' do
    before { create(:developer_onboarding, :joined_to_slack, user: user) }

    it 'check users in team' do
      expect(service).to receive(:team_member?).with(user.email)
      subject
    end

    it 'user in the team and not change status slack' do
      allow(service).to receive(:team_member?).with(any_args).and_return(true)
      subject
      expect(user.developer_onboarding.reload.slack_status).to eq 'slack_joined'
    end

    it 'user is not in the team and change status slack to left' do
      allow(service).to receive(:team_member?).with(any_args).and_return(false)
      expect { subject }.to change { user.developer_onboarding.slack_status }
        .from('slack_joined').to('slack_left')
    end
  end
end
