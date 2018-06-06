# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::Start do
  describe '#call' do
    let(:user) { create(:user, :developer) }
    let(:number_of_test_tasks) { described_class::NUMBER_OF_ASSIGNED_TEST_TASKS }

    context 'no test tasks exist' do
      it 'does not assign test tasks to user' do
        expect { described_class.call(user: user) }
          .to change { user.test_task_assignments.count }
          .by(0)
      end
    end

    context 'one test tasks disabled' do
      before { create(:role_with_test_task_disabled) }

      it 'does not assign test tasks to user' do
        expect { described_class.call(user: user) }
          .to change { user.test_task_assignments.count }
          .by(0)
      end
    end

    context 'less test tasks exist than required number' do
      before { create(:role_with_one_test_task) }

      it 'assigns all existing test tasks to user' do
        expect { described_class.call(user: user) }
          .to change { user.test_task_assignments.count }
          .by(Developer::TestTask.count)
      end
    end

    context 'multiple test tasks exist' do
      before { create(:role_with_test_tasks) }

      it 'assigns all existing test tasks to user' do
        expect { described_class.call(user: user) }
          .to change { user.test_task_assignments.count }
          .by(number_of_test_tasks)
      end
    end
  end
end
