# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::VotePolicy do
  subject { described_class.new(user, idea) }

  context 'staff or mentor' do
    let(:user) { create(:user, :staff_or_mentor, :active) }

    shared_examples 'staff or mentor main actions' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.not_to permit_action(:up) }
      it { is_expected.not_to permit_action(:down) }
    end

    context 'idea status pending' do
      let(:idea) { create(:idea) }

      it_behaves_like 'staff or mentor main actions'
    end

    context 'idea status voting' do
      let(:idea) { create(:idea, :voting) }

      it_behaves_like 'staff or mentor main actions'
    end

    context 'idea status disabled' do
      let(:idea) { create(:idea, :disabled) }

      it_behaves_like 'staff or mentor main actions'
    end

    context 'idea status active' do
      let(:idea) { create(:idea, :active) }

      it_behaves_like 'staff or mentor main actions'
    end
  end

  context 'author' do
    let(:user) { create(:user, :author, :active) }

    shared_examples 'author main actions' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.not_to permit_action(:up) }
      it { is_expected.not_to permit_action(:down) }
    end

    context 'idea status pending' do
      let(:idea) { create(:idea, author: user) }

      it_behaves_like 'author main actions'
    end

    context 'idea status voting' do
      let(:idea) { create(:idea, :voting, author: user) }

      it_behaves_like 'author main actions'
    end

    context 'idea status disabled' do
      let(:idea) { create(:idea, :disabled, author: user) }

      it_behaves_like 'author main actions'
    end

    context 'idea status active' do
      let(:idea) { create(:idea, :active, author: user) }

      it_behaves_like 'author main actions'
    end
  end

  context 'member' do
    let(:user) { create(:user, :member, :active) }

    shared_examples 'member main actions' do
      it { is_expected.to permit_action(:index) }
      it { is_expected.not_to permit_action(:up) }
      it { is_expected.not_to permit_action(:down) }
    end

    context 'idea status pending' do
      let(:idea) { create(:idea) }

      it_behaves_like 'member main actions'
      it { is_expected.not_to permit_action(:voting_panel) }
    end

    context 'idea status voting' do
      let(:idea) { create(:idea, :voting) }

      context 'current user did not vote' do
        it { is_expected.to permit_action(:index) }
        it { is_expected.to permit_action(:up) }
        it { is_expected.to permit_action(:down) }
        it { is_expected.to permit_action(:voting_panel) }
      end

      context 'current user has voted' do
        let!(:vote) { create(:vote, user: user, idea: idea) }

        it_behaves_like 'member main actions'
        it { is_expected.to permit_action(:voting_panel) }
      end
    end

    context 'idea status disabled' do
      let(:idea) { create(:idea, :disabled) }

      it_behaves_like 'member main actions'
      it { is_expected.not_to permit_action(:voting_panel) }
    end

    context 'idea status active' do
      let(:idea) { create(:idea, :active) }

      it_behaves_like 'member main actions'
      it { is_expected.not_to permit_action(:voting_panel) }
    end
  end
end
