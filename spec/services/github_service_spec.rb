# frozen_string_literal: true

require 'rails_helper'
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

  describe '#create_team' do
    let(:team_name) { 'team_name' }
    let(:privacy) { 'closed' }
    let(:params) do
      {
        name: 'team_name',
        description: 'team_name',
        privacy: 'closed'
      }
    end

    it 'calls #create_team in Github api client' do
      allow(client).to receive(:create_team).with(organization, params)
      subject.create_team(team_name, privacy)
    end
  end

  describe '#invite_member' do
    let(:user_id)   { 123 }
    let(:username)  { 'super-developer' }
    let(:team_name) { 'mentors' }
    let(:team_id)   { 234 }
    let(:teams_response) do
      [
        { name: team_name, id: team_id }
      ]
    end

    before do
      allow(client)
        .to receive(:user)
        .with(user_id)
        .and_return(login: username)
      allow(client)
        .to receive(:organization_teams)
        .and_return(teams_response)
    end

    it 'adds member to organization and team' do
      allow(client)
        .to receive(:add_team_membership)
        .with(team_id, username)
      subject.invite_member(user_id, team_name)
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
        allow(client)
          .to receive(:add_team_membership)
          .with(team_id, username)
          .and_raise(Octokit::Forbidden, bad_response)
      end

      it 'does not raise error' do
        expect { subject.invite_member(user_id, team_name) }
          .not_to raise_error
      end
    end

    context 'no team with defined name found' do
      it 'raises exception' do
        expect { subject.invite_member(user_id, 'non-existing-team') }
          .to raise_error GithubIntegration::NoTeamFoundException
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
          .to receive(:add_team_membership)
          .with(team_id, username)
          .and_raise(Octokit::Forbidden, bad_response)
      end

      it 'reraises exception' do
        expect { subject.invite_member(user_id, team_name) }.to raise_error Octokit::Forbidden
      end
    end
  end

  describe '#username_by_email' do
    before { github_response_template }

    context 'found user by email' do
      let(:email) { 'opensource@howtohireme.ru' }
      let(:response) do
        { total_count: 1,
          incomplete_results: false,
          items: [{ login: 'reabiliti',
                    id: 30_253_042,
                    score: 16.607306 }] }
      end
      let(:result) { 'reabiliti' }
      before { allow(client).to receive(:search_users).with(email).and_return(response) }

      it 'query generation' do
        subject.username_by_email(email)
      end

      it 'does not raise error' do
        expect { subject.username_by_email(email) }.not_to raise_error
      end

      it 'return user name' do
        expect(subject.username_by_email(email)).to eq result
      end
    end

    context 'user not found by email' do
      let(:email) { 'not-opensource@howtohireme.ru' }
      let(:request) do
        { total_count: 0,
          incomplete_results: false,
          items: [] }
      end

      it 'raise error' do
        allow(client).to receive(:search_users).with(email).and_return(request)
        expect { subject.username_by_email(email) }.to raise_error GithubIntegration::UsernameResolveException
      end
    end
  end
end
