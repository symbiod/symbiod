# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::AssignTestTasks do
  subject { described_class.call(user: user, positions: positions) }
  describe '#call' do
    let!(:user) { create(:user, :member, :with_primary_skill, :policy_accepted) }
    let!(:positions) { Ops::Member::Screening::Start::NUMBER_OF_ASSIGNED_TEST_TASKS }
    let!(:role) { user.roles.first }
    let!(:skill) { user.primary_skill }
    let!(:query) { double }
    before do
      allow(TestTasks::ForApplicationQuery)
        .to receive(:new)
        .with(positions, user)
        .and_return(query)
    end

    shared_examples 'run query test tasks' do
      it 'run query test tasks' do
        expect(query).to receive(:call)
        subject
      end
    end

    context 'no test tasks' do
      it_behaves_like 'run query test tasks'

      it 'complete screening' do
        allow(query).to receive(:call).and_return([])
        expect(Ops::Member::Screening::Finish).to receive(:call).with(user: user)
        subject
      end

      it 'does not assign test tasks to user' do
        allow(query).to receive(:call).and_return([])
        expect { subject }.to change { user.test_task_assignments.count }.by(0)
      end
    end

    context 'exist test tasks' do
      let!(:test_task_1) { create(:member_test_task, skill: skill, role_name: role.name) }
      let!(:test_task_2) { create(:member_test_task, skill: skill, role_name: role.name) }

      it_behaves_like 'run query test tasks'

      it 'complete screening not calls' do
        allow(query).to receive(:call).and_return([test_task_1, test_task_2])
        expect(Ops::Member::Screening::Finish).not_to receive(:call).with(user: user)
        subject
      end

      it 'assign test tasks to user' do
        allow(query).to receive(:call).and_return([test_task_1, test_task_2])
        expect { subject }.to change { user.test_task_assignments.count }.by(2)
      end
    end
  end
end
