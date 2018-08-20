# frozen_string_literal: true

require 'rails_helper'

describe Users::ScreeningUncompletedUsersQuery do
  subject { described_class.new.call }

  describe '#call return array' do
    let!(:candidate)  { create(:user, :developer, :pending) }
    let!(:candidate1) { create(:user, :developer, :policy_accepted) }
    let!(:candidate2) { create(:user, :developer, :profile_completed) }
    let!(:candidate3) { create(:user, :developer, :active) }
    let!(:candidate4) { create(:user, :developer, :disabled) }
    let!(:candidate5) { create(:user, :developer, :rejected) }
    let!(:candidate6) { create(:user, :developer, :screening_completed) }
    let!(:candidate7) { create(:user, :developer, :not_screening_completed) }

    it 'returns only correct recipients' do
      is_expected.to match_array [candidate, candidate1, candidate2]
    end
  end
end
