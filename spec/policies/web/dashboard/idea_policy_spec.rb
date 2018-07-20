# frozen_string_literal: true

require 'rails_helper'

shared_examples 'permit main actions' do
  it { is_expected.to permit_action(:index) }
  it { is_expected.to permit_action(:show) }
  it { is_expected.to permit_action(:new) }
  it { is_expected.to permit_action(:create) }
  it { is_expected.to permit_action(:edit) }
  it { is_expected.to permit_action(:update) }
end

describe Dashboard::IdeaPolicy do
  subject { described_class.new(user, nil) }

  context 'staff user' do
    let(:user) { create(:user, :staff, :active) }

    it_behaves_like 'permit main actions'
    it { is_expected.to permit_action(:activate) }
    it { is_expected.to permit_action(:deactivate) }
    it { is_expected.to permit_action(:reject) }
  end

  context 'mentor user' do
    let!(:user) { create(:user, :mentor) }

    it_behaves_like 'permit main actions'
    it { is_expected.to permit_action(:activate) }
    it { is_expected.to permit_action(:deactivate) }
    it { is_expected.to permit_action(:reject) }
  end

  context 'author user' do
    let!(:user) { create(:user, :author, :active) }

    it_behaves_like 'permit main actions'
    it { is_expected.not_to permit_action(:activate) }
    it { is_expected.not_to permit_action(:deactivate) }
    it { is_expected.not_to permit_action(:reject) }
  end

  context 'developer user' do
    let!(:user) { create(:user, :developer, :active) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:activate) }
    it { is_expected.not_to permit_action(:deactivate) }
    it { is_expected.not_to permit_action(:reject) }
  end

  describe 'scope' do
    subject { described_class::Scope.new(current_user, User) }
    let(:idea_1) { create(:idea, :disabled) }
    let(:idea_2) { create(:idea, :active) }
    let(:idea_3) { create(:idea, :active) }

    context 'current user role staff or mentor' do
      let(:current_user) { create(:user, :staff_or_mentor, :active) }

      it 'returns all ideas' do
        expect(subject.resolve).to match_array [idea_1, idea_2, idea_3]
      end
    end

    context 'current user role developer' do
      let(:current_user) { create(:user, :developer, :active) }

      it 'returns activated ideas' do
        expect(subject.resolve).to match_array [idea_2, idea_3]
      end
    end

    context 'current user role developer and author' do
      let(:current_user) { create(:user, :developer, :author, :active) }
      let(:idea_4) { create(:idea, :active, author: current_user) }

      it 'returns activated and current author ideas' do
        expect(subject.resolve).to match_array [idea_2, idea_3, idea_4]
      end
    end

    context 'current user role author' do
      let(:current_user) { create(:user, :author, :active) }
      let(:idea_4) { create(:idea, :active, author: current_user) }

      it 'returns current author ideas' do
        expect(subject.resolve).to match_array [idea_4]
      end
    end
  end
end
