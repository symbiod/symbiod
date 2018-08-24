# frozen_string_literal: true

require 'rails_helper'

describe Onboarding::UsersInvitedAndJoinedSlackQuery do
  subject { described_class.call }

  describe '#call' do
    let(:user_1) { create(:user, :developer, :active) }
    let(:user_2) { create(:user, :developer, :active) }
    let(:user_3) { create(:user, :developer, :active) }
    let(:user_4) { create(:user, :developer, :active) }
    before do
      create(:developer_onboarding, :invited_to_slack, user: user_1)
      create(:developer_onboarding, :invited_to_slack, user: user_2)
      create(:developer_onboarding, user: user_3)
      create(:developer_onboarding, :left_slack, user: user_4)
    end

    it 'return only correct users' do
      is_expected.to match_array [user_1, user_2]
    end

    its(:size) { is_expected.to eq 2 }
  end
end
