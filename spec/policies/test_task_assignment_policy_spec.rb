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

  context 'developer state screening_completed and user staff' do
    let(:user) { create(:user, :staff) }
    let(:developer) { create(:user, :screening_completed) }

    it { is_expected.to permit_action(:review, developer) }
  end

  describe 'scope' do
    subject { described_class::Scope.new(user, User) }
    let(:skill_name) { 'Ruby' }
    let!(:applicant_1) { create(:user, :screening_completed, :with_primary_skill, skill_name: skill_name) }
    let!(:applicant_2) { create(:user, :screening_completed, :with_primary_skill, skill_name: 'Java') }
    let!(:applicant_3) { create(:user, :screening_completed) }
    let!(:applicant_4) { create(:user, :profile_completed, :with_primary_skill, skill_name: skill_name) }

    context 'staff' do
      let(:user) { create(:user, :staff) }

      it 'returns all applicants' do
        expect(subject.resolve).to match_array [applicant_1, applicant_2, applicant_3]
      end
    end

    context 'mentor' do
      let(:user) { create(:user, :mentor, :with_primary_skill, skill_name: skill_name) }

      it 'returns matching applicants' do
        expect(subject.resolve).to match_array [applicant_1]
      end
    end

    context 'developer' do
      let(:user) { create(:user, :developer, :with_primary_skill, skill_name: skill_name) }

      it 'returns empty collection' do
        expect(subject.resolve).to eq []
      end
    end
  end
end
