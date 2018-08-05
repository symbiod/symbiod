# frozen_string_literal: true

require 'rails_helper'

describe Bootcamp::Wizard::AcceptPolicyPolicy do
  subject { described_class.new(user, nil) }

  context 'unauthenticated user' do
    let(:user) { nil }
    it { is_expected.not_to permit_action(:edit) }
  end

  context 'user with complete_profile' do
    let(:user) { create(:user, :developer, :profile_completed) }
    it { is_expected.to permit_action(:edit) }
  end
end
