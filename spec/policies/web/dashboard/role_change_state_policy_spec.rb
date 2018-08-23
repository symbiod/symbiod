# frozen_string_literal: true

require 'rails_helper'

describe Dashboard::RoleChangeStatePolicy do
  subject { described_class.new(user, nil) }

  context 'current user has role staff or mentor' do
    let(:user) { create(:user, :staff_or_mentor, :active) }

    it { is_expected.to permit_action(:update) }
  end

  context 'current user has role author or developer' do
    let(:user) { create(:user, :developer_or_author, :active) }

    it { is_expected.not_to permit_action(:update) }
  end
end
