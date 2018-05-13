# frozen_string_literal: true

require 'rails_helper'

describe TestTaskPolicy do
  subject { described_class.new(user, nil) }

  context 'staff user' do
    let(:user) { create(:user, :staff) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:edit) }
    it { is_expected.to permit_action(:update) }
  end

  context 'active user' do
    let(:user) { create(:user, :active) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:edit) }
    it { is_expected.not_to permit_action(:update) }
  end
end
