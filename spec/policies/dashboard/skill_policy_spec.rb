# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::SkillPolicy do
  subject { described_class.new(user, nil) }

  context 'user has role staff or mentor' do
    let(:user) { create(:user, :staff_or_mentor, :active) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:activate) }
    it { is_expected.to permit_action(:deactivate) }
  end

  context 'user has role member or author' do
    let!(:user) { create(:user, :member_or_author, :active) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:activate) }
    it { is_expected.not_to permit_action(:deactivate) }
  end
end
