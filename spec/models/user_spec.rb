# frozen_string_literal: true

require 'rails_helper'
require 'aasm/rspec'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { create(:user) }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
    it { is_expected.to have_many(:test_task_assignments) }
  end

  it { is_expected.to have_many :ideas }

  describe 'users default state and role' do
    let(:user) { create(:user, :with_name) }

    it 'users default role is developer' do
      expect(user.has_role?(:developer)).to eq(true)
    end

    it 'users default have state pending' do
      expect(user).to have_state(:pending)
    end
  end

  describe 'changes in users states' do
    let(:user) { create(:user, :with_name) }

    it 'activate user' do
      expect(user).to transition_from(:pending).to(:active).on_event(:activate)
      expect(user).to transition_from(:disabled).to(:active).on_event(:activate)
    end

    it 'disable user' do
      expect(user).to transition_from(:active).to(:disabled).on_event(:disable)
    end

    it 'reject user' do
      expect(user).to transition_from(:pending).to(:rejected).on_event(:reject)
    end
  end

  describe 'changes in users roles' do
    let(:user) { create(:user, :with_name) }

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

  describe '#screening_completed?' do
    subject { create(:developer) }

    context 'has uncompleted test tasks' do
      before { create(:developer_test_task_assignment, :uncompleted, developer: subject) }
      specify { expect(subject.screening_completed?).to eq false }
    end

    context 'all tasks are completed' do
      before { create(:developer_test_task_assignment, :completed) }
      specify { expect(subject.screening_completed?).to eq true }
    end
  end
end
