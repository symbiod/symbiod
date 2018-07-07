# frozen_string_literal: true

require 'rails_helper'

shared_examples 'without right on create idea' do
  it { is_expected.to permit_action(:index) }
  it { is_expected.not_to permit_action(:create) }
end

describe Ideas::ProposalPolicy do
  subject { described_class.new(user, nil) }

  context 'staff user without ideas' do
    let(:user) { create(:user, :staff) }

    it_behaves_like 'without right on create idea'
  end

  context 'active user developer whitout ideas' do
    let(:user) { create(:user, :developer, :active) }

    it_behaves_like 'without right on create idea'
  end

  context 'active user author without ideas' do
    let(:user) { create(:user, :author) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:create) }
  end

  context 'active user author with idea' do
    let(:user) { create(:user, :author, :with_idea) }

    it_behaves_like 'without right on create idea'
  end
end
