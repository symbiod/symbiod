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
  let!(:candidate7) { create(:role, :member, :pending, :registered_5_days_ago) }
  let!(:candidate8) { create(:role, :member, :profile_completed, :registered_5_days_ago) }
  let!(:candidate9) { create(:role, :member, :policy_accepted, :registered_5_days_ago) }
  let!(:candidate10) { create(:role, :member, :active, :registered_5_days_ago) }
  let!(:candidate11) { create(:role, :member, :disabled, :registered_5_days_ago) }
  let!(:candidate12) { create(:role, :member, :rejected, :registered_5_days_ago) }
  let!(:candidate13) { create(:role, :member, :screening_completed, :registered_5_days_ago) }


  subject { described_class.new.call }

  context '#call' do
    it 'returns only correct recipients' do
      is_expected.to match_array [candidate7, candidate8, candidate9]
    end

    its(:size) { is_expected.to eq 3 }
  end
end
