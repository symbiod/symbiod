# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
  end

  describe 'relations' do
    it { is_expected.to have_many :ideas }
    it { is_expected.to have_many :test_task_assignments }
    it { is_expected.to have_many :user_skills }
    it { is_expected.to have_many :skills }
    it { is_expected.to have_many :approved_users }
    it { is_expected.to have_many :notes }
    it { is_expected.to have_many :project_users }
    it { is_expected.to have_many :projects }
    it { is_expected.to belong_to(:approver).optional }
  end

  describe '.with_role_and_state' do
    subject { described_class.with_role_and_state(role, state) }
    let!(:user1) { create(:user, :member, :profile_completed) }
    let!(:user2) { create(:user, :member, :policy_accepted) }
    let!(:user3) { create(:user, :author, :pending) }
    let!(:user4) { create(:user, :staff, :active) }

    context 'member with profile_completed' do
      let(:role) { :member }
      let(:state) { :profile_completed }
      it { is_expected.to eq [user1] }
    end

    context 'member with policy_accepted' do
      let(:role) { :member }
      let(:state) { :policy_accepted }
      it { is_expected.to eq [user2] }
    end

    context 'pending author' do
      let(:role) { :author }
      let(:state) { :pending }
      it { is_expected.to eq [user3] }
    end

    context 'active staff' do
      let(:role) { :staff }
      let(:state) { :active }
      it { is_expected.to eq [user4] }
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
      before { create(:member_test_task_assignment, :uncompleted, member: subject) }
      specify { expect(subject.test_tasks_completed?).to eq false }
    end

    context 'all tasks are completed' do
      before { create(:member_test_task_assignment, :completed) }
      specify { expect(subject.test_tasks_completed?).to eq true }
    end
  end

  describe '#progress' do
    context 'returns a number' do
      before { create(:member_test_task_assignment, :uncompleted, member: subject) }

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
