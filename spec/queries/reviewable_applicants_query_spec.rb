# frozen_string_literal: true

require 'rails_helper'

describe ReviewableApplicantsQuery do
  subject { described_class.new(mentor).call }
  let!(:skill_name) { 'Ruby' }
  let!(:mentor) { create(:user, :mentor, :with_primary_skill, skill_name: skill_name) }

  let!(:applicant_1) { create(:user, :developer, :with_primary_skill, :screening_completed, skill_name: skill_name) }
  let!(:applicant_2) { create(:user, :developer, :with_primary_skill, :screening_completed, skill_name: skill_name) }
  let!(:applicant_3) { create(:user, :developer, :with_primary_skill, :screening_completed, skill_name: 'Java') }

  describe '#call' do
    it 'returns only applicants with suitable skill' do
      is_expected.to match_array [applicant_1, applicant_2]
    end
  end
end
