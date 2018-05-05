# frozen_string_literal: true

require 'rails_helper'

describe Ops::Developer::Screening::CompleteTask do
  subject { described_class }

  describe '#call' do
    let(:user) { create(:user) }
    let(:assignment) { create(:developer_test_task_assignment, :uncompleted, developer: user) }
    let(:params) { Hash[link: 'some answer'] }

    it 'makes assignment completed' do
      expect do
        subject.call(user: user, assignment_id: assignment.id, params: params)
      end.to change { assignment.reload.completed? }.from(false).to(true)
    end

    it 'calls Finish operation' do
      allow(::Ops::Developer::Screening::Finish)
        .to receive(:call).with(user: user)
    end
  end
end
