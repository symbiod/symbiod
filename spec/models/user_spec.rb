# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
  end

  describe 'relations' do
    it { is_expected.to have_many :ideas }
    it { is_expected.to have_many :test_task_assignments }
  end

  describe 'users default state and role' do
    it 'users default role is developer' do
      expect(user.has_role?(:developer)).to eq(true)
    end

    it 'users default have state pending' do
      expect(user).to have_state(:pending)
    end
  end

  describe 'changes in users states' do
    it 'completes screening' do
      expect(user).to transition_from(:pending).to(:screening_completed).on_event(:complete_screening)
    end

    it 'activate user' do
      expect(user).to transition_from(:screening_completed).to(:active).on_event(:activate)
      expect(user).to transition_from(:disabled).to(:active).on_event(:activate)
    end

    it 'disable user' do
      expect(user).to transition_from(:active).to(:disabled).on_event(:disable)
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

    it 'stuff role can be added' do
      user.add_role(:stuff)
      expect(user.has_role?(:stuff)).to eq(true)
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
end
