# frozen_string_literal: true

require 'rails_helper'

describe TestTaskAssignmentPolicy do
  subject { described_class.new(user, nil) }

  context 'staff user' do
    let(:user) { create(:user, :staff) }

    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:activate) }
    it { is_expected.to permit_action(:reject) }
  end

  context 'active user' do
    let(:user) { create(:user, :active) }

    it { is_expected.not_to permit_action(:index) }
    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:activate) }
    it { is_expected.not_to permit_action(:reject) }
  end
end
