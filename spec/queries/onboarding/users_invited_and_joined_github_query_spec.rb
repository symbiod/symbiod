# frozen_string_literal: true

require 'rails_helper'

describe Onboarding::UsersInvitedAndJoinedGithubQuery do
  subject { described_class.call }

  describe '#call' do
    let(:user_1) { create(:user, :member, :active) }
    let(:user_2) { create(:user, :member, :active) }
    let(:user_3) { create(:user, :member, :active) }
    let(:user_4) { create(:user, :member, :active) }
    before do
      create(:member_onboarding, :invited_to_github, user: user_1)
      create(:member_onboarding, :invited_to_github, user: user_2)
      create(:member_onboarding, user: user_3)
      create(:member_onboarding, :left_github, user: user_4)
    end

    it 'return only correct users' do
      is_expected.to match_array [user_1, user_2]
    end

    its(:size) { is_expected.to eq 2 }
  end
end
