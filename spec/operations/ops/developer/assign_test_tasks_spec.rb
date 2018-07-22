# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::AssignTestTasks do
  describe '#call' do
    let(:user) { create(:user, :developer, :with_primary_skill) }
    let(:positions) { Ops::Developer::Screening::Start::NUMBER_OF_ASSIGNED_TEST_TASKS }
    let(:role) { user.roles.first }
    let(:skill) { user.primary_skill }

    describe 'number of available tasks' do
      context 'no test tasks exist' do
        it 'does not assign test tasks to user' do
          expect { described_class.call(user: user, positions: positions) }
            .to change { user.test_task_assignments.count }
            .by(0)
        end
      end

      context 'all test tasks are disabled' do
        before do
          create_list(:developer_test_task, 2, :disabled, skill: skill, role_name: role.name)
        end

        it 'does not assign test tasks to user' do
          expect { described_class.call(user: user, positions: positions) }
            .to change { user.test_task_assignments.count }
            .by(0)
        end
      end

      context 'less test tasks exist than required number' do
        before do
          create(:developer_test_task, skill: skill, role_name: role.name)
        end

        it 'assigns all existing test tasks to user' do
          expect { described_class.call(user: user, positions: positions) }
            .to change { user.test_task_assignments.count }
            .by(Developer::TestTask.count)
        end
      end

      context 'multiple test tasks exist' do
        before do
          # We can't use here create_list since the position field in the factory
          # is shuffled, and in case if we create two first positioned records,
          # then the spec will fail
          create(:developer_test_task, :first_position, skill: skill, role_name: role.name)
          create(:developer_test_task, :second_position, skill: skill, role_name: role.name)
          create(:developer_test_task, :first_position, skill: skill, role_name: role.name)
        end

        it 'assigns all existing test tasks to user' do
          expect { described_class.call(user: user, positions: positions) }
            .to change { user.test_task_assignments.reload.count }
            .by(positions)
        end
      end

      context 'no test tasks with proper skill' do
        let(:another_skill) { create(:skill) }

        before do
          create_list(:developer_test_task, positions + 1, skill: another_skill, role_name: role.name)
        end

        it 'does not assign test tasks' do
          expect { described_class.call(user: user, positions: positions) }
            .not_to(change { user.test_task_assignments.count })
        end
      end
    end
  end
end
