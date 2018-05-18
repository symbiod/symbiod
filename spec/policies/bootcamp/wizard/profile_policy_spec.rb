require 'rails_helper'

describe Bootcamp::Wizard::ProfilePolicy do
  subject { described_class.new(user, nil) }

  context 'unauthenticated user' do
    let(:user) { nil }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'pending user' do
    let(:user) { create(:user) }
    it { is_expected.to permit_action(:edit) }
  end

  context 'profile_completed user' do
    let(:user) { create(:user, :profile_completed) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'screening_completed user' do
    let(:user) { create(:user, :screening_completed) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'active user' do
    let(:user) { create(:user, :active) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'disabled user' do
    let(:user) { create(:user, :disabled) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'rejected user' do
    let(:user) { create(:user, :rejected) }
    it { is_expected.not_to permit_action(:edit) }
  end
end
