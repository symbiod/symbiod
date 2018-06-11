# frozen_string_literal: true

require 'rails_helper'

describe Users::ScreeningCompletedNotificationRecipientsQuery do
  subject { described_class.new(applicant).call }
  let(:applicant) { create(:developer, :with_primary_skill) }
  let(:skill_name) { applicant.primary_skill.title }

  describe '#call' do
    let!(:staff_1)   { create(:user, :staff, :with_primary_skill) }
    let!(:staff_2)   { create(:user, :staff) }
    let!(:mentor_1)  { create(:user, :mentor, :with_primary_skill, skill_name: skill_name) }
    let!(:mentor_2)  { create(:user, :mentor, :with_primary_skill) }
    let!(:developer) { create(:user, :developer, :with_primary_skill, skill_name: skill_name) }

    it 'returns only correct recipients' do
      is_expected.to match_array [staff_1, staff_2, mentor_1]
    end
  end
end
