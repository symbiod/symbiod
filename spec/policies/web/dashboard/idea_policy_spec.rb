# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::IdeaPolicy do
  subject { described_class.new(user, idea) }

  context 'staff or mentor' do
    let(:user) { create(:user, :staff_or_mentor, :active) }

    shared_examples 'permit main actions' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:manage) }
    end

    context 'author idea current user' do
      context 'idea status pending' do
        let(:idea) { create(:idea, author: user) }

        it_behaves_like 'permit main actions'
        it { is_expected.to permit_action(:voting) }
        it { is_expected.not_to permit_action(:activate) }
        it { is_expected.not_to permit_action(:deactivate) }
        it { is_expected.not_to permit_action(:reject) }
      end

      context 'idea status voting' do
        let(:idea) { create(:idea, :voting, author: user) }

        it_behaves_like 'permit main actions'
        it { is_expected.not_to permit_action(:voting) }
        it { is_expected.to permit_action(:activate) }
        it { is_expected.not_to permit_action(:deactivate) }
        it { is_expected.not_to permit_action(:reject) }
      end

      context 'idea status disabled' do
        let(:idea) { create(:idea, :disabled, author: user) }

        it_behaves_like 'permit main actions'
        it { is_expected.not_to permit_action(:voting) }
        it { is_expected.to permit_action(:activate) }
        it { is_expected.not_to permit_action(:deactivate) }
        it { is_expected.not_to permit_action(:reject) }
      end

      context 'idea status active' do
        let(:idea) { create(:idea, :active, author: user) }

        it_behaves_like 'permit main actions'
        it { is_expected.not_to permit_action(:voting) }
        it { is_expected.not_to permit_action(:activate) }
        it { is_expected.to permit_action(:deactivate) }
        it { is_expected.not_to permit_action(:reject) }
      end
    end

    context 'author idea not current user' do
      context 'idea status pending' do
        let(:idea) { create(:idea) }

        it_behaves_like 'permit main actions'
        it { is_expected.to permit_action(:voting) }
        it { is_expected.not_to permit_action(:activate) }
        it { is_expected.not_to permit_action(:deactivate) }
        it { is_expected.to permit_action(:reject) }
      end

      context 'idea status voting' do
        let(:idea) { create(:idea, :voting) }

        it_behaves_like 'permit main actions'
        it { is_expected.not_to permit_action(:voting) }
        it { is_expected.to permit_action(:activate) }
        it { is_expected.not_to permit_action(:deactivate) }
        it { is_expected.to permit_action(:reject) }
      end

      context 'idea status disabled' do
        let(:idea) { create(:idea, :disabled) }

        it_behaves_like 'permit main actions'
        it { is_expected.not_to permit_action(:voting) }
        it { is_expected.to permit_action(:activate) }
        it { is_expected.not_to permit_action(:deactivate) }
        it { is_expected.not_to permit_action(:reject) }
      end

      context 'idea status active' do
        let(:idea) { create(:idea, :active) }

        it_behaves_like 'permit main actions'
        it { is_expected.not_to permit_action(:voting) }
        it { is_expected.not_to permit_action(:activate) }
        it { is_expected.to permit_action(:deactivate) }
        it { is_expected.not_to permit_action(:reject) }
      end
    end
  end

  context 'author' do
    let(:user) { create(:user, :author, :active) }

    context 'author idea current user' do
      shared_examples 'author current user main actions' do
        it { is_expected.to permit_action(:index) }
        it { is_expected.to permit_action(:show) }
        it { is_expected.to permit_action(:new) }
        it { is_expected.to permit_action(:create) }
        it { is_expected.to permit_action(:edit) }
        it { is_expected.to permit_action(:update) }
        it { is_expected.not_to permit_action(:manage) }
        it { is_expected.not_to permit_action(:voting) }
        it { is_expected.not_to permit_action(:activate) }
        it { is_expected.not_to permit_action(:deactivate) }
        it { is_expected.not_to permit_action(:reject) }
      end

      context 'idea status pending' do
        let(:idea) { create(:idea, author: user) }

        it_behaves_like 'author current user main actions'
      end

      context 'idea status voting' do
        let(:idea) { create(:idea, :voting, author: user) }

        it_behaves_like 'author current user main actions'
      end

      context 'idea status disabled' do
        let(:idea) { create(:idea, :disabled, author: user) }

        it_behaves_like 'author current user main actions'
      end

      context 'idea status active' do
        let(:idea) { create(:idea, :active, author: user) }

        it_behaves_like 'author current user main actions'
      end
    end

    context 'author idea not current user' do
      shared_examples 'author main actions' do
        it { is_expected.to permit_action(:index) }
        it { is_expected.not_to permit_action(:show) }
        it { is_expected.to permit_action(:new) }
        it { is_expected.to permit_action(:create) }
        it { is_expected.not_to permit_action(:edit) }
        it { is_expected.not_to permit_action(:update) }
        it { is_expected.not_to permit_action(:manage) }
        it { is_expected.not_to permit_action(:voting) }
        it { is_expected.not_to permit_action(:activate) }
        it { is_expected.not_to permit_action(:deactivate) }
        it { is_expected.not_to permit_action(:reject) }
      end

      context 'idea status pending' do
        let(:idea) { create(:idea) }

        it_behaves_like 'author main actions'
      end

      context 'idea status voting' do
        let(:idea) { create(:idea, :voting) }

        it_behaves_like 'author main actions'
      end

      context 'idea status disabled' do
        let(:idea) { create(:idea, :disabled) }

        it_behaves_like 'author main actions'
      end

      context 'idea status active' do
        let(:idea) { create(:idea, :active) }

        it_behaves_like 'author main actions'
      end
    end
  end

  context 'member' do
    let(:user) { create(:user, :member, :active) }

    shared_examples 'member main actions' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.not_to permit_action(:new) }
      it { is_expected.not_to permit_action(:create) }
      it { is_expected.not_to permit_action(:edit) }
      it { is_expected.not_to permit_action(:update) }
      it { is_expected.not_to permit_action(:manage) }
      it { is_expected.not_to permit_action(:voting) }
      it { is_expected.not_to permit_action(:activate) }
      it { is_expected.not_to permit_action(:deactivate) }
      it { is_expected.not_to permit_action(:reject) }
    end

    context 'idea status pending' do
      let(:idea) { create(:idea) }

      it_behaves_like 'member main actions'
      it { is_expected.not_to permit_action(:show) }
    end

    context 'idea status voting' do
      let(:idea) { create(:idea, :voting) }

      it_behaves_like 'member main actions'
      it { is_expected.to permit_action(:show) }
    end

    context 'idea status disabled' do
      let(:idea) { create(:idea, :disabled) }

      it_behaves_like 'member main actions'
      it { is_expected.not_to permit_action(:show) }
    end

    context 'idea status active' do
      let(:idea) { create(:idea, :active) }

      it_behaves_like 'member main actions'
      it { is_expected.not_to permit_action(:show) }
    end
  end

  describe 'scope' do
    subject { described_class::Scope.new(current_user, User) }
    let!(:idea_1) { create(:idea, :disabled) }
    let!(:idea_2) { create(:idea, :active) }
    let!(:idea_3) { create(:idea, :active) }
    let!(:idea_4) { create(:idea, :voting) }

    context 'current user role staff or mentor' do
      let(:current_user) { create(:user, :staff_or_mentor, :active) }

      it 'returns all ideas' do
        expect(subject.resolve).to match_array [idea_1, idea_2, idea_3, idea_4]
      end
    end

    context 'current user role member' do
      let(:current_user) { create(:user, :member, :active) }

      it 'returns activated ideas' do
        expect(subject.resolve).to match_array [idea_4]
      end
    end

    context 'current user role member and author' do
      let(:current_user) { create(:user, :member, :author, :active) }
      let(:idea_5) { create(:idea, :active, author: current_user) }

      it 'returns activated and current author ideas' do
        expect(subject.resolve).to match_array [idea_4, idea_5]
      end
    end

    context 'current user role author' do
      let(:current_user) { create(:user, :author, :active) }
      let(:idea_5) { create(:idea, :active, author: current_user) }

      it 'returns current author ideas' do
        expect(subject.resolve).to match_array [idea_5]
      end
    end
  end
end
