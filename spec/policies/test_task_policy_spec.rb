# frozen_string_literal: true

require 'rails_helper'

shared_examples 'permit_all_actions' do
  it { is_expected.to permit_action(:index) }
  it { is_expected.to permit_action(:new) }
  it { is_expected.to permit_action(:create) }
  it { is_expected.to permit_action(:edit) }
  it { is_expected.to permit_action(:update) }
  it { is_expected.to permit_action(:activate) }
  it { is_expected.to permit_action(:deactivate) }
end

describe TestTaskPolicy do
  subject { described_class.new(user, nil) }

  context 'staff user' do
    let(:user) { create(:user, :staff) }

    it_behaves_like 'permit_all_actions'
  end

  context 'mentor user' do
    let!(:user) { create(:user, :mentor) }

    it_behaves_like 'permit_all_actions'
  end

  context 'active user' do
    let!(:user) { create(:user, :active) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
  end
end
