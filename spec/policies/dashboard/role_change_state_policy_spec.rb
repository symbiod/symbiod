# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::RoleChangeStatePolicy do
  subject { described_class.new(user, nil) }

  describe 'update?' do
    context 'current user has role staff or mentor' do
      let(:user) { create(:user, :staff_or_mentor, :active) }

      it { is_expected.to permit_action(:update) }
    end

    context 'current user has role author or member' do
      let(:user) { create(:user, :member_or_author, :active) }

      it { is_expected.not_to permit_action(:update) }
    end
  end

  describe 'force_activate?' do
    subject { described_class.new(user, role) }

    context 'user is staff' do
      let(:user) { create(:user, :staff) }

      context 'the role is active' do
        let(:role) { create(:role, :member, :active) }
        it { is_expected.not_to permit_action(:force_activate) }
      end

      context 'the role is pending' do
        let(:role) { create(:role, :member, :pending) }
        it { is_expected.to permit_action(:force_activate) }
      end

      context 'role is nil' do
        let(:role) { nil }
        it { is_expected.not_to permit_action(:force_activate) }
      end
    end

    context 'user is mentor' do
      let(:user) { create(:user, :mentor, :active) }
      let(:role) { create(:role, :member, :pending) }

      it { is_expected.not_to permit_action(:force_activate) }
    end
  end
end
