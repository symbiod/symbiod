# frozen_string_literal: true

require 'rails_helper'

describe Ops::Projects::GenerateProjectGithubTeam do
  subject { described_class }
  let!(:user) { create(:user, :member, :active) }
  let!(:mentor) { create(:user, :mentor, :active) }
  let!(:service) { double }

  describe '#call' do
    before do
      allow(GithubService).to receive(:new).with(any_args).and_return(service)
      create(:project_user, project: project, user: mentor, mentor: true)
      project.users << user
    end

    shared_examples 'generate team' do
      it 'create repo' do
        expect(service).to receive(:create_repository).with(project.slug)
        allow(service).to receive(:create_team).with(any_args)
        allow(service).to receive(:add_user_to_team).with(any_args)
        subject.call(params)
      end

      it 'create team' do
        allow(service).to receive(:create_repository).with(any_args)
        expect(service).to receive(:create_team).with(project.name, privacy, repo_names)
        allow(service).to receive(:add_user_to_team).with(any_args)
        subject.call(params)
      end

      it 'add members to team' do
        allow(service).to receive(:create_repository).with(any_args)
        allow(service).to receive(:create_team).with(any_args)
        expect(service).to receive(:add_user_to_team).with(project.name, user.github)
        expect(service).to receive(:add_user_to_team).with(project.name, mentor.github)
        expect(service).to receive(:add_user_to_team).with(project.name, author.github)
        subject.call(params)
      end
    end

    context 'open projects' do
      let(:idea) { create(:idea, :with_project) }
      let(:project) { idea.project }
      let(:author) { project.author }
      let(:privacy) { 'closed' }
      let(:repo_names) { ["#{Settings.github.organization}/#{project.slug}"] }
      let(:params) { { project: project } }

      it_behaves_like 'generate team'
    end

    context 'private projects' do
      let(:idea) { create(:idea, :with_project, :private_project) }
      let(:project) { idea.project }
      let(:author) { project.author }
      let(:privacy) { 'secret' }
      let(:repo_names) { ["#{Settings.github.organization}/#{project.slug}"] }
      let(:params) { { project: project } }

      it_behaves_like 'generate team'
    end

    context 'skip bootstraping' do
      let(:idea) { create(:idea, :with_project, :skip_bootstrapping) }
      let(:project) { idea.project }
      let(:author) { project.author }
      let(:privacy) { 'closed' }
      let(:repo_names) { [] }
      let(:params) { { project: project } }

      it 'create team' do
        expect(service).to receive(:create_team).with(project.name, privacy, repo_names)
        allow(service).to receive(:add_user_to_team).with(any_args)
        subject.call(params)
      end

      it 'add members to team' do
        allow(service).to receive(:create_team).with(any_args)
        expect(service).to receive(:add_user_to_team).with(project.name, user.github)
        expect(service).to receive(:add_user_to_team).with(project.name, mentor.github)
        expect(service).to receive(:add_user_to_team).with(project.name, author.github)
        subject.call(params)
      end
    end
  end
end
