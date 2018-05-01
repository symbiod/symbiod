# frozen_string_literal: true

module Developer
  # Represents an assigned test task to specific developer.
  # We consider it completed, when corresponding `test_task_result` is created for this task.
  class TestTaskAssignment < ApplicationRecord
    belongs_to :test_task,
               class_name: 'Developer::TestTask',
               foreign_key: 'test_task_id'
    belongs_to :test_task_result,
               class_name: 'Developer::TestTaskResult',
               foreign_key: 'test_task_result_id',
               optional: true
    belongs_to :developer, class_name: 'User', foreign_key: 'developer_id'

    scope :uncompleted, -> { where(test_task_result_id: nil) }
  end
end
