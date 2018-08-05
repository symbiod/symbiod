# frozen_string_literal: true

require 'rails_helper'

describe Bootcamp::Wizard::ProfilePolicy do
  subject { described_class.new(user, nil) }

  context 'unauthenticated user' do
    let(:user) { nil }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'pending user' do
    let(:user) { create(:user, :developer) }
    it { is_expected.to permit_action(:edit) }
  end

  # TODO: write some kind of macros, that generates the following list of specs.
  # I want just to pass the list of states, and state that they should not be allowed
  # to pass this policy
  context 'profile_completed user' do
    let(:user) { create(:user, :developer, :profile_completed) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'policy_accepted user' do
    let(:user) { create(:user, :developer, :policy_accepted) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'screening_completed user' do
    let(:user) { create(:user, :developer, :screening_completed) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'active user' do
    let(:user) { create(:user, :developer, :active) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'disabled user' do
    let(:user) { create(:user, :developer, :disabled) }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'rejected user' do
    let(:user) { create(:user, :developer, :rejected) }
    it { is_expected.not_to permit_action(:edit) }
  end
end
