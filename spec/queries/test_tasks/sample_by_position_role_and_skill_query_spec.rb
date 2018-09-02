# frozen_string_literal: true

require 'rails_helper'

describe TestTasks::ByPositionRoleAndSkillQuery do
  subject { described_class.new(position, user).call }
  let!(:user) { create(:user, :member, :with_primary_skill) }
  let!(:position) { 1 }
  let!(:role) { user.roles.first }
  let!(:skill) { user.primary_skill }

  describe '#call' do
    context 'all test tasks are disabled' do
      let!(:test_task_1) { create(:member_test_task, :disabled, skill: skill, role_name: role.name) }
      let!(:test_task_2) { create(:member_test_task, :disabled, skill: skill, role_name: role.name) }
      let!(:test_task_3) { create(:member_test_task, :disabled, skill: skill, role_name: role.name) }

      it 'returns empty array' do
        is_expected.to eq []
      end
    end

    context 'multiple test tasks exist' do
      let!(:test_task_1) { create(:member_test_task, :first_position, skill: skill, role_name: role.name) }
      let!(:test_task_2) { create(:member_test_task, :second_position, skill: skill, role_name: role.name) }
      let!(:test_task_3) { create(:member_test_task, :first_position, skill: skill, role_name: role.name) }

      its(:size) { is_expected.to eq 2 }
    end

    context 'no test tasks with proper skill' do
      let!(:another_skill) { create(:skill) }
      let!(:test_task_1) { create(:member_test_task, :first_position, skill: another_skill, role_name: role.name) }
      let!(:test_task_2) { create(:member_test_task, :second_position, skill: another_skill, role_name: role.name) }
      let!(:test_task_3) { create(:member_test_task, :first_position, skill: another_skill, role_name: role.name) }

      it 'returns empty array' do
        is_expected.to eq []
      end
    end

    context 'no test tasks with role name' do
      let!(:test_task_1) { create(:member_test_task, :first_position, skill: skill) }
      let!(:test_task_2) { create(:member_test_task, :second_position, skill: skill) }
      let!(:test_task_3) { create(:member_test_task, :first_position, skill: skill) }

      it 'returns empty array' do
        is_expected.to eq []
      end
    end
  end
end
