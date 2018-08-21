# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::NotePolicy do
  subject { described_class.new(user, note) }

  context 'current user has role staff or mentor' do
    let(:user) { create(:user, :staff_or_mentor, :active) }

    shared_examples 'allowed' do
      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'current user commenter note' do
      let(:note) { create(:note, commenter: user) }

      it_behaves_like 'allowed'
      it { is_expected.to permit_action(:edit) }
      it { is_expected.to permit_action(:update) }
    end

    context 'current user not commenter note' do
      let(:note) { create(:note) }

      it_behaves_like 'allowed'
      it { is_expected.not_to permit_action(:edit) }
      it { is_expected.not_to permit_action(:update) }
    end
  end

  context 'current user has role author or developer' do
    let(:user) { create(:user, :active, :developer_or_author) }
    let(:note) { create(:note) }

    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:destroy) }
  end
end
