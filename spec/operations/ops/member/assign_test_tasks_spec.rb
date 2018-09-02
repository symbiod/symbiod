# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::AssignTestTasks do
  subject { described_class.call(user: user, positions: positions) }
  describe '#call' do
    let!(:user) { create(:user, :member, :with_primary_skill, :policy_accepted) }
    let!(:positions) { Ops::Member::Screening::Start::NUMBER_OF_ASSIGNED_TEST_TASKS }
    let!(:role) { user.roles.first }
    let!(:skill) { user.primary_skill }

    shared_examples 'no test tasks' do
      it 'does not assign test tasks to user' do
        expect { subject }.to change { user.test_task_assignments.count }.by(0)
      end

      it 'calls complete screening' do
        expect(Ops::Member::Screening::Finish).to receive(:call).with(user: user)
        subject
      end
    end

    shared_examples 'complete screening not calls' do
      it 'complete screening not calls' do
        expect(Ops::Member::Screening::Finish).not_to receive(:call).with(user: user)
        subject
      end
    end

    describe 'number of available tasks' do
      context 'no test tasks exist' do
        it_behaves_like 'no test tasks'
      end

      context 'all test tasks are disabled' do
        before do
          create_list(:member_test_task, 2, :disabled, skill: skill, role_name: role.name)
        end

        it_behaves_like 'no test tasks'
      end

      context 'less test tasks exist than required number' do
        before do
          create(:member_test_task, skill: skill, role_name: role.name)
        end

        it 'assigns all existing test tasks to user' do
          expect { subject }
            .to change { user.test_task_assignments.count }
            .by(Member::TestTask.count)
        end

        it_behaves_like 'complete screening not calls'
      end

      context 'multiple test tasks exist' do
        before do
          # We can't use here create_list since the position field in the factory
          # is shuffled, and in case if we create two first positioned records,
          # then the spec will fail
          create(:member_test_task, :first_position, skill: skill, role_name: role.name)
          create(:member_test_task, :second_position, skill: skill, role_name: role.name)
          create(:member_test_task, :first_position, skill: skill, role_name: role.name)
        end

        it 'assigns all existing test tasks to user' do
          expect { subject }.to change { user.test_task_assignments.reload.count }.by(positions)
        end

        it_behaves_like 'complete screening not calls'
      end

      context 'no test tasks with proper skill' do
        let(:another_skill) { create(:skill) }

        before do
          create_list(:member_test_task, positions + 1, skill: another_skill, role_name: role.name)
        end

        it_behaves_like 'no test tasks'
      end
    end
  end
end
