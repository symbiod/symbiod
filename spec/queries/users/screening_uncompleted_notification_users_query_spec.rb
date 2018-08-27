# frozen_string_literal: true

require 'rails_helper'

describe Users::ScreeningUncompletedUsersQuery do
  let!(:candidate)  { create(:user, :member, :pending) }
  let!(:candidate1) { create(:user, :member, :profile_completed) }
  let!(:candidate2) { create(:user, :member, :policy_accepted) }
  let!(:candidate3) { create(:user, :member, :active) }
  let!(:candidate4) { create(:user, :member, :disabled) }
  let!(:candidate5) { create(:user, :member, :rejected) }
  let!(:candidate6) { create(:user, :member, :screening_completed) }

  subject { described_class.new.call }

  context '#call' do
    it 'returns only correct recipients' do
      is_expected.to match_array [candidate, candidate1, candidate2]
    end
  end
end
