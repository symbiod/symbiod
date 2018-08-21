# frozen_string_literal: true

require 'rails_helper'

describe Ideas::Wizard::RegistrationPolicy do
  subject { described_class.new(user, nil) }

  context 'user exists' do
    let(:user) { create(:user, :author) }

    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:authorized) }
  end

  context 'no user' do
    let(:user) { nil }

    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:authorized) }
  end
end
