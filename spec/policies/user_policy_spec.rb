# frozen_string_literal: true

require 'rails_helper'

describe UserPolicy do
  subject { described_class.new(user, nil) }

  shared_examples 'denied changes' do
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:activate) }
    it { is_expected.not_to permit_action(:deactivate) }
    it { is_expected.not_to permit_action(:add_role) }
    it { is_expected.not_to permit_action(:remove_role) }
    it { is_expected.not_to permit_action(:manage_roles) }
  end

  context 'current user has role staff' do
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

  context 'current user has role member' do
    let(:user) { create(:user, :mentor_or_member, :active) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it_behaves_like 'denied changes'
  end

  context 'current user has role author' do
    let(:user) { create(:user, :author, :active) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:show) }
    it_behaves_like 'denied changes'
  end

  context 'user was approved' do
    let(:approver) { create(:user, :staff, :active) }
    let(:user) { create(:user, :author, :active, approver_id: approver.id) }

    it 'acces to approved policy' do
      expect(described_class.new(approver, user)).to permit_action(:approved)
    end
  end
end
