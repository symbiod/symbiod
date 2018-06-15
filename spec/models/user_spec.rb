# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
    it { is_expected.to validate_presence_of :location }
    it { is_expected.to validate_presence_of :timezone }
    it { is_expected.to validate_presence_of :cv_url }
  end

  describe 'relations' do
    it { is_expected.to have_many :ideas }
    it { is_expected.to have_many :test_task_assignments }
    it { is_expected.to have_many :user_skills }
    it { is_expected.to have_many :skills }
    it { is_expected.to have_many :approveds }
    it { is_expected.to belong_to :approver }
  end

  describe 'users default state' do
    it 'users default have state pending' do
      expect(user).to have_state(:pending)
    end
  end

  describe 'changes in users states' do
    it 'accept policy' do
      expect(user)
        .to transition_from(:pending).to(:policy_accepted)
                                     .on_event(:accept_policy)
    end

    it 'completes profile' do
      expect(user)
        .to transition_from(:policy_accepted).to(:profile_completed).on_event(:complete_profile)
    end

    it 'completes screening' do
      expect(user)
        .to transition_from(:profile_completed).to(:screening_completed)
                                               .on_event(:complete_screening)
    end

    it 'activate user' do
      expect(user)
        .to transition_from(:screening_completed).to(:active)
                                                 .on_event(:activate)
      expect(user)
        .to transition_from(:disabled).to(:active)
                                      .on_event(:activate)
    end

    it 'disable user' do
      expect(user)
        .to transition_from(:active).to(:disabled)
                                    .on_event(:disable)
    end

    it 'reject user' do
      expect(user).to transition_from(:screening_completed).to(:rejected).on_event(:reject)
    end
  end

  describe 'changes in users roles' do
    it 'author role can be added' do
      user.add_role(:author)
      expect(user.has_role?(:author)).to eq(true)
    end

    it 'staff role can be added' do
      user.add_role(:staff)
      expect(user.has_role?(:staff)).to eq(true)
    end

    it 'invalid role can not be added' do
      user.add_role(:invalid)
      expect(user.has_role?(:invalid)).to eq(false)
    end
  end

  describe '#test_tasks_completed?' do
    context 'has uncompleted test tasks' do
      before { create(:developer_test_task_assignment, :uncompleted, developer: subject) }
      specify { expect(subject.test_tasks_completed?).to eq false }
    end

    context 'all tasks are completed' do
      before { create(:developer_test_task_assignment, :completed) }
      specify { expect(subject.test_tasks_completed?).to eq true }
    end
  end

  describe '#progress' do
    context 'returns a number' do
      before { create(:developer_test_task_assignment, :uncompleted, developer: subject) }

      it { expect(subject.progress).to be_an(Numeric) }
    end
  end

  describe '#github_uid' do
    context 'no authentications' do
      its(:github_uid) { is_expected.to eq nil }
    end

    context 'several authentications' do
      let!(:auth1) { create(:authentication, :github, user: subject) }
      let!(:auth2) { create(:authentication, :github, user: subject) }

      its(:github_uid) { is_expected.to eq auth1.uid }
    end
  end

  describe '#primary_skill' do
    let(:skill) { create(:skill) }

    context 'user not have primary skill' do
      it 'return nil' do
        expect(subject.primary_skill).to eq nil
      end
    end

    context 'user have primary skill' do
      before { create(:user_skill, :primary, user: subject, skill: skill) }

      it 'return primary skill' do
        expect(subject.primary_skill).to eq skill
      end
    end
  end
end
