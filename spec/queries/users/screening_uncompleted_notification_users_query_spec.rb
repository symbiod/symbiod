# frozen_string_literal: true

require 'rails_helper'

describe Roles::Screening::UncompletedRolesQuery do
  let!(:candidate)  { create(:role, :member, :pending) }
  let!(:candidate1) { create(:role, :member, :profile_completed) }
  let!(:candidate2) { create(:role, :member, :policy_accepted) }
  let!(:candidate3) { create(:role, :member, :active) }
  let!(:candidate4) { create(:role, :member, :disabled) }
  let!(:candidate5) { create(:role, :member, :rejected) }
  let!(:candidate6) { create(:role, :member, :screening_completed) }

  subject { described_class.new.call }

  context '#call' do
    it 'returns only correct recipients' do
      is_expected.to match_array [candidate, candidate1, candidate2]
    end
  end
end
