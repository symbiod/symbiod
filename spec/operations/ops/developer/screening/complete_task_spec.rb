# frozen_string_literal: true

require 'rails_helper'

describe Ops::Member::Screening::CompleteTask do
  subject { described_class }

  shared_examples 'assigns model to context' do
    it 'assigns model' do
      result = subject.call(user: user, assignment_id: assignment.id, params: params)
      expect(result[:model]).to eq assignment
    end
  end

  describe '#call' do
    let(:user) { create(:user, :member, :policy_accepted) }
    let!(:assignment) { create(:member_test_task_assignment, :uncompleted, member: user) }

    context 'valid params' do
      let(:params) { Hash[link: 'some answer'] }

      it 'makes assignment completed' do
        expect do
          subject.call(user: user, assignment_id: assignment.id, params: params)
        end.to change { assignment.reload.completed? }.from(false).to(true)
      end

      it 'creates result record' do
        expect do
          subject.call(user: user, assignment_id: assignment.id, params: params)
        end.to change(Member::TestTaskResult, :count).by(1)
      end

      it 'calls Finish operation' do
        expect(::Ops::Member::Screening::Finish)
          .to receive(:call).with(user: user)
        subject.call(user: user, assignment_id: assignment.id, params: params)
      end

      include_examples 'assigns model to context'
    end

    context 'invalid params' do
      let(:params) { Hash[link: nil] }

      it 'does not make assignment completed' do
        expect do
          subject.call(user: user, assignment_id: assignment.id, params: params)
        end.not_to change { assignment.reload.completed? }.from(false)
      end

      it 'does not create result record' do
        expect do
          subject.call(user: user, assignment_id: assignment.id, params: params)
        end.not_to change(Member::TestTaskResult, :count)
      end

      it 'does not call Finish operation' do
        expect(::Ops::Member::Screening::Finish)
          .not_to receive(:call).with(user: user)
        subject.call(user: user, assignment_id: assignment.id, params: params)
      end

      include_examples 'assigns model to context'
    end
  end
end
