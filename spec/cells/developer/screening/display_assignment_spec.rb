# frozen_string_literal: true

require 'rails_helper'

describe Member::Screening::DisplayAssignment do
  subject { described_class.new(assignment) }
  let(:assignment) { create(:member_test_task_assignment, :uncompleted) }

  describe '#assignment' do
    context 'test_task_result is assigned' do
      let(:test_task_result) { create(:member_test_task_result) }

      before do
        assignment.test_task_result = test_task_result
      end

      it 'returns unsaved record' do
        expect(subject.assignment).to eq test_task_result
      end
    end

    context 'no test_task_result' do
      it 'returns unsaved record' do
        expect(subject.assignment.new_record?).to eq true
      end
    end
  end
end
