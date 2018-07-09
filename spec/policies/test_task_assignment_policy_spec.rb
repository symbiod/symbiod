# frozen_string_literal: true

require 'rails_helper'

describe TestTaskAssignmentPolicy do
  subject { described_class.new(current_user, candidate) }

  shared_examples 'access to all' do
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:activate) }
    it { is_expected.to permit_action(:reject) }
    it { is_expected.to permit_action(:review) }
  end

  shared_examples 'prohibited except for the index' do
    it { is_expected.not_to permit_action(:show) }
    it { is_expected.not_to permit_action(:activate) }
    it { is_expected.not_to permit_action(:reject) }
    it { is_expected.not_to permit_action(:review) }
  end

  context 'current user status staff' do
    let(:current_user) { create(:user, :staff) }

    context 'candidate status screening_completed' do
      let(:candidate) { create(:user, :screening_completed) }

      it_behaves_like 'access to all'
    end

    context 'candidate status not screening_completed' do
      let(:candidate) { create(:user, :not_screening_completed) }

      it { is_expected.to permit_action(:index) }
      it_behaves_like 'prohibited except for the index'
    end
  end

  context 'current user status mentor' do
    let(:skill_name) { 'Ruby' }
    let(:current_user) { create(:user, :mentor, :with_primary_skill, skill_name: skill_name) }

    context 'candidate status screening_completed and primary skill as metor' do
      let(:candidate) { create(:user, :screening_completed, :with_primary_skill, skill_name: skill_name) }

      it_behaves_like 'access to all'
    end

    context 'candidate status screening_completed and not primary skill as metor' do
      let(:candidate) { create(:user, :screening_completed) }

      it { is_expected.to permit_action(:index) }
      it_behaves_like 'prohibited except for the index'
    end

    context 'candidate status not screening_completed' do
      let(:candidate) { create(:user, :not_screening_completed) }

      it { is_expected.to permit_action(:index) }
      it_behaves_like 'prohibited except for the index'
    end
  end

  context 'current user status active' do
    let(:current_user) { create(:user, :active) }
    let(:candidate) { create(:user, :screening_completed) }

    it { is_expected.not_to permit_action(:index) }
    it_behaves_like 'prohibited except for the index'
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
