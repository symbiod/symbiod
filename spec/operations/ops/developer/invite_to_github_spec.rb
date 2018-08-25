# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::InviteToGithub do
  subject       { described_class }
  let(:user)    { create(:user, :authenticated_through_github) }
  let(:params)  { { user: user } }
  let(:service) { double }
  before { user.create_developer_onboarding }

  describe '#call' do
    before do
      allow(GithubService).to receive(:new).with(any_args).and_return(service)
    end

    it 'invites member to Github' do
      expect(service).to receive(:invite_member).with(user.github_uid, Settings.github.default_team)
      subject.call(params)
    end

    it 'users change github status' do
      allow(service).to receive(:invite_member).with(user.github_uid, Settings.github.default_team)
      expect { subject.call(params) }.to change { user.developer_onboarding.reload.github_status }
        .from('github_pending').to('github_invited')
    end
  end
end
