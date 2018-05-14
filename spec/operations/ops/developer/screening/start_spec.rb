# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::Start do
  describe '#call' do
    let(:user) { create(:user) }
    let(:number_of_test_tasks) { described_class::NUMBER_OF_ASSIGNED_TEST_TASKS }

    context 'no test tasks exist' do
      it 'does not assign test tasks to user' do
        expect { described_class.call(user: user) }
          .to change { user.test_task_assignments.count }
          .by(0)
      end
    end

    context 'less test tasks exist than required number' do
      before { create_list(:developer_test_task, number_of_test_tasks - 1) }

      it 'assigns all existing test tasks to user' do
        expect { described_class.call(user: user) }
          .to change { user.test_task_assignments.count }
          .by(Developer::TestTask.count)
      end
    end

    context 'multiple test tasks exist' do
      before { create_list(:developer_test_task, 100) }

      it 'assigns all existing test tasks to user' do
        expect { described_class.call(user: user) }
          .to change { user.test_task_assignments.count }
          .by(number_of_test_tasks)
      end
    end
  end
end
