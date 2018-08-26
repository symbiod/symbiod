# frozen_string_literal: true

require 'rails_helper'

describe DashboardPolicy do
  subject { described_class.new(user, nil) }

  context 'unauthenticated user' do
    let(:user) { nil }
    it { is_expected.not_to permit_action(:index) }
  end

  context 'active member' do
    let(:user) { create(:user, :member, :active) }
    it { is_expected.to permit_action(:index) }
  end

  context 'disabled member' do
    let(:user) { create(:user, :member, :disabled) }
    it { is_expected.not_to permit_action(:index) }
  end

  context 'active mentor' do
    let(:user) { create(:user, :mentor, :active) }
    it { is_expected.to permit_action(:index) }
  end

  context 'disabled mentor' do
    let(:user) { create(:user, :mentor, :disabled) }
    it { is_expected.not_to permit_action(:index) }
  end

  context 'active staff' do
    let(:user) { create(:user, :staff) }
    it { is_expected.to permit_action(:index) }
  end

  context 'disabled staff' do
    let(:user) { create(:user, :staff, :disabled) }
    it { is_expected.not_to permit_action(:index) }
  end
end
