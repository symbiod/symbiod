# frozen_string_literal: true

module Member
  # Represents an assigned test task to specific member.
  # We consider it completed, when corresponding `test_task_result` is created for this task.
  class TestTaskAssignment < ApplicationRecord
    belongs_to :test_task,
               class_name: 'Member::TestTask',
               foreign_key: 'test_task_id'
    belongs_to :test_task_result,
               class_name: 'Member::TestTaskResult',
               foreign_key: 'test_task_result_id',
               optional: true,
               inverse_of: :test_task_assignment
    belongs_to :member, class_name: 'User', foreign_key: 'member_id'

    scope :uncompleted, -> { where(test_task_result_id: nil) }
    scope :completed, -> { where('test_task_result_id IS NOT NULL') }

    MAX_NUMBER_OF_ASSIGNMENTS = 5

    def completed?
      test_task_result.present?
    end
  end
end
