# frozen_string_literal: true

require 'rails_helper'

describe DashboardPolicy do
  subject { described_class.new(user, nil) }

  context 'unauthenticated user' do
    let(:user) { nil }
    it { is_expected.not_to permit_action(:allowed) }
  end

  context 'active developer' do
    let(:user) { create(:user, :developer, :active) }
    it { is_expected.to permit_action(:allowed) }
  end

  context 'disabled developer' do
    let(:user) { create(:user, :developer, :disabled) }
    it { is_expected.not_to permit_action(:allowed) }
  end

  context 'active mentor' do
    let(:user) { create(:user, :mentor, :active) }
    it { is_expected.to permit_action(:allowed) }
  end

  context 'disabled mentor' do
    let(:user) { create(:user, :mentor, :disabled) }
    it { is_expected.not_to permit_action(:allowed) }
  end

  context 'active staff' do
    let(:user) { create(:user, :staff) }
    it { is_expected.to permit_action(:allowed) }
  end

  context 'disabled staff' do
    let(:user) { create(:user, :staff, :disabled) }
    it { is_expected.not_to permit_action(:allowed) }
  end
end
