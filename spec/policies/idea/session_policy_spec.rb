# frozen_string_literal: true

require 'rails_helper'

describe Ideas::SessionPolicy do
  subject { described_class.new(user, nil) }

  context 'user exists' do
    let(:user) { create(:user, :member) }

    it { is_expected.not_to permit_action(:new) }
    it { is_expected.not_to permit_action(:create) }
  end

  context 'no user' do
    let(:user) { nil }

    it { is_expected.to permit_action(:new) }
    it { is_expected.to permit_action(:create) }
  end
end
