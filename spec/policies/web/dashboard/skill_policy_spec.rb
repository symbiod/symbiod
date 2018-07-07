# frozen_string_literal: true

require 'rails_helper'

shared_examples 'access allowed' do
  it { is_expected.to permit_action(:index) }
  it { is_expected.to permit_action(:new) }
  it { is_expected.to permit_action(:create) }
  it { is_expected.to permit_action(:edit) }
  it { is_expected.to permit_action(:update) }
  it { is_expected.to permit_action(:activate) }
  it { is_expected.to permit_action(:deactivate) }
end

shared_examples 'access is denied' do
  it { is_expected.not_to permit_action(:index) }
  it { is_expected.not_to permit_action(:new) }
  it { is_expected.not_to permit_action(:create) }
  it { is_expected.not_to permit_action(:edit) }
  it { is_expected.not_to permit_action(:update) }
  it { is_expected.not_to permit_action(:activate) }
  it { is_expected.not_to permit_action(:deactivate) }
end

describe Dashboard::SkillPolicy do
  subject { described_class.new(user, nil) }

  context 'staff user' do
    let(:user) { create(:user, :staff, :active) }

    it_behaves_like 'access allowed'
  end

  context 'mentor user' do
    let!(:user) { create(:user, :mentor) }

    it_behaves_like 'access allowed'
  end

  context 'author user' do
    let!(:user) { create(:user, :author, :active) }

    it_behaves_like 'access is denied'
  end

  context 'developer user' do
    let!(:user) { create(:user, :developer, :active) }

    it_behaves_like 'access is denied'
  end
end
