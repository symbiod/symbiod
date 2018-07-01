# frozen_string_literal: true

require 'rails_helper'

describe UserPolicy do
  subject { described_class.new(user, nil) }

  context 'staff user' do
    let(:user) { create(:user, :staff) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:activate) }
    it { is_expected.to permit_action(:deactivate) }
    it { is_expected.to permit_action(:add_role) }
    it { is_expected.to permit_action(:remove_role) }
    it { is_expected.to permit_action(:manage_roles) }
  end

  context 'active user developer' do
    let(:user) { create(:user, :developer, :active) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:activate) }
    it { is_expected.not_to permit_action(:deactivate) }
    it { is_expected.not_to permit_action(:add_role) }
    it { is_expected.not_to permit_action(:remove_role) }
    it { is_expected.not_to permit_action(:manage_roles) }
  end

  context 'active user author' do
    let(:user) { create(:user, :author, :active) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:activate) }
    it { is_expected.not_to permit_action(:deactivate) }
    it { is_expected.not_to permit_action(:add_role) }
    it { is_expected.not_to permit_action(:remove_role) }
    it { is_expected.not_to permit_action(:manage_roles) }
  end
end
