# frozen_string_literal: true

require 'rails_helper'

shared_examples 'not allowed to create idea' do
  it { is_expected.to permit_action(:index) }
  it { is_expected.not_to permit_action(:create) }
end

shared_examples 'allowed to create idea' do
  it { is_expected.to permit_action(:index) }
  it { is_expected.to permit_action(:create) }
end

describe Ideas::Wizard::ProposalPolicy do
  subject { described_class.new(user, nil) }

  context 'staff user without ideas' do
    let(:user) { create(:user, :staff) }

    it_behaves_like 'not allowed to create idea'
  end

  context 'active user member without ideas' do
    let(:user) { create(:user, :member, :active) }

    it_behaves_like 'not allowed to create idea'
  end

  context 'active user author without ideas' do
    let(:user) { create(:user, :author) }

    it_behaves_like 'allowed to create idea'
  end

  context 'active user author with idea' do
    let(:user) { create(:user, :author, :with_idea) }

    it_behaves_like 'allowed to create idea'
  end
end
