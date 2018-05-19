# frozen_string_literal: true

require 'spec_helper'
require './app/services/github_service'

describe GithubService do
  subject { described_class.new(token, organization) }
  let(:client)       { double }
  let(:organization) { 'howtohireme' }
  let(:token)        { '123456' }

  before do
    allow_any_instance_of(described_class)
      .to receive(:client)
      .and_return(client)
  end

  describe '#create_repository' do
    let(:repo_name) { 'new_repo' }
    let(:params) do
      {
        organization: organization
      }
    end

    it 'calls #create_repository in Github api client' do
      allow(client).to receive(:create_repository).with(repo_name, params)
      subject.create_repository(repo_name)
    end
  end

  describe '#invite_member' do
    let(:user_id)  { 123 }
    let(:username) { 'super-developer' }

    before do
      allow(client)
        .to receive(:user)
        .with(user_id)
        .and_return(login: username)
    end

    context 'team name is provided' do
      let(:team) { 'mentors' }

      it 'adds member to organization and team' do
        allow(client)
          .to receive(:update_organization_membership)
          .with(organization, user: username)
        allow(client)
          .to receive(:add_team_member)
          .with(team, username)
        subject.invite_member(user_id, team)
      end
    end

    context 'no team name' do
      it 'adds member to bootcamp team' do
        allow(client)
          .to receive(:update_organization_membership)
          .with(organization, user: username)
        allow(client)
          .to receive(:add_team_member)
          .with('bootcamp', username)
        subject.invite_member(user_id)
      end
    end

    context 'self-demote exception raised' do
      let(:bad_response) do
        {
          method: 'PUT',
          url: 'https://api.github.com/orgs/howtohireme/memberships/Mehonoshin',
          status: 403,
          response_header: {},
          body: 'You cannot demote yourself. Admins must be demoted by another admin. // See: https://developer.github.com/v3/orgs/members/#add-or-update-organization-membership'
        }
      end

      before do
        expect(client)
          .to receive(:update_organization_membership)
          .with(organization, user: username)
          .and_raise(Octokit::Forbidden, bad_response)
      end

      it 'does not raise error' do
        expect{subject.invite_member(user_id)}
          .not_to raise_error
      end
    end

    context 'some other exception raised' do
      let(:bad_response) do
        {
          method: 'PUT',
          url: 'https://api.github.com/orgs/howtohireme/memberships/Mehonoshin',
          status: 403,
          response_header: {},
          body: 'Some other drammatic error'
        }
      end

      before do
        expect(client)
          .to receive(:update_organization_membership)
          .with(organization, user: username)
          .and_raise(Octokit::Forbidden, bad_response)
      end

      it 'reraises exception' do
        expect { subject.invite_member(user_id) }.to raise_error Octokit::Forbidden
      end
    end
  end
end
