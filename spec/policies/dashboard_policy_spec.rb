# frozen_string_literal: true

require 'rails_helper'

describe DashboardPolicy do
  subject { described_class.new(user, nil) }

  context 'unauthenticated user' do
    let(:user) { nil }
    it { is_expected.not_to permit_action(:allowed) }
  end

  context 'pending user' do
    let(:user) { create(:user) }
    it { is_expected.not_to permit_action(:allowed) }
  end

  context 'active user' do
    let(:user) { create(:user, :active) }
    it { is_expected.to permit_action(:allowed) }
  end

  context 'user with staff role' do
    let(:user) { create(:user, :staff) }
    it { is_expected.to permit_action(:allowed) }
  end
end
