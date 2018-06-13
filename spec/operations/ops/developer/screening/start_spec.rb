# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::Start do
  describe '#call' do
    let(:user)  { create(:user, :developer, :with_primary_skill) }
    let(:skill) { user.primary_skill }
    let(:role)  { user.roles.first }
    let(:number_of_test_tasks) { described_class::NUMBER_OF_ASSIGNED_TEST_TASKS }

    describe 'number of available tasks' do
      context 'no test tasks exist' do
        it 'does not assign test tasks to user' do
          expect { described_class.call(user: user) }
            .to change { user.test_task_assignments.count }
            .by(0)
        end
      end

      context 'all test tasks are disabled' do
        before do
          create_list(:developer_test_task, 2, :disabled, skill: skill, role: role)
        end

        it 'does not assign test tasks to user' do
          expect { described_class.call(user: user) }
            .to change { user.test_task_assignments.count }
            .by(0)
        end
      end

      context 'less test tasks exist than required number' do
        before do
          create(:developer_test_task, skill: skill, role: role)
        end

        it 'assigns all existing test tasks to user' do
          expect { described_class.call(user: user) }
            .to change { user.test_task_assignments.count }
            .by(Developer::TestTask.count)
        end
      end

      context 'multiple test tasks exist' do
        before do
          create_list(:developer_test_task, number_of_test_tasks + 1, skill: skill, role: role)
        end

        it 'assigns all existing test tasks to user' do
          expect { described_class.call(user: user) }
            .to change { user.test_task_assignments.reload.count }
            .by(number_of_test_tasks)
        end
      end

      context 'no test tasks with proper skill' do
        let(:another_skill) { create(:skill) }

        before do
          create_list(:developer_test_task, number_of_test_tasks + 1, skill: another_skill, role: role)
        end

        it 'does not assign test tasks' do
          expect { described_class.call(user: user) }
            .not_to change { user.test_task_assignments.count }
        end
      end
    end
  end
end
