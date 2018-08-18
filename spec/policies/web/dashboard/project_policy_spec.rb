# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::ProjectPolicy do
  subject { described_class.new(user, idea.project) }

  shared_examples 'permit main actions' do
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
  end

  shared_examples 'not permit main actions' do
    it { is_expected.to permit_action(:index) }
    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
  end

  context 'current user has role staff or mentor' do
    let(:user) { create(:user, :staff_or_mentor, :active) }
    let(:idea) { create(:idea, :with_project) }

    it_behaves_like 'permit main actions'
  end

  context 'current user has role author' do
    let!(:user) { create(:user, :author, :active) }

    context 'user author project' do
      let(:idea) { create(:idea, :with_project, author: user) }

      it_behaves_like 'permit main actions'
    end

    context 'user not author project' do
      let(:idea) { create(:idea, :with_project) }

      it_behaves_like 'not permit main actions'
    end
  end

  context 'current user has role developer' do
    let!(:user) { create(:user, :developer, :active) }
    let!(:idea) { create(:idea, :with_project) }

    context 'user member project' do
      before { create(:project_user, project: idea.project, user: user) }

      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.not_to permit_action(:edit) }
      it { is_expected.not_to permit_action(:update) }
    end

    context 'user not member project' do
      it_behaves_like 'not permit main actions'
    end
  end

  describe 'scope' do
    subject { described_class::Scope.new(current_user, User) }
    let!(:idea_1) { create(:idea, :with_project, author: current_user) }
    let!(:idea_2) { create(:idea, :with_project, author: current_user) }
    let!(:idea_3) { create(:idea, :with_project) }
    let!(:idea_4) { create(:idea, :with_project) }

    context 'current user has role staff or mentor' do
      let(:current_user) { create(:user, :staff_or_mentor, :active) }

      it 'returns all projects' do
        expect(subject.resolve)
          .to match_array [idea_1.project, idea_2.project, idea_3.project, idea_4.project]
      end
    end

    context 'current user has role author' do
      let(:current_user) { create(:user, :author, :active) }

      it 'return projects where user author' do
        expect(subject.resolve)
          .to match_array [idea_1.project, idea_2.project]
      end
    end

    context 'current user has role developer' do
      before { create(:project_user, project: idea_4.project, user: current_user) }
      let(:current_user) { create(:user, :developer, :active) }

      it 'returns projects where current user member' do
        expect(subject.resolve)
          .to match_array [idea_4.project]
      end
    end
  end
end
