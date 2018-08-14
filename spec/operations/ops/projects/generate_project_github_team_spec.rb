# frozen_string_literal: true

require 'rails_helper'

describe Ops::Projects::GenerateProjectGithubTeam do
  subject { described_class }
  let!(:project) { create(:project) }
  let!(:user) { create(:user, :developer, :active) }
  let!(:author) { project.author }
  let!(:mentor) { create(:user, :mentor, :active) }
  let!(:service) { double }

  describe '#call' do
    let!(:params) { { project: project } }
    before do
      allow(GithubService).to receive(:new).with(any_args).and_return(service)
      create(:project_user, project: project, user: mentor, mentor: true)
      project.users << user
    end

    it 'create team' do
      expect(service).to receive(:create_team).with(project.name)
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
