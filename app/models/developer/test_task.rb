# frozen_string_literal: true

module Developer
  # Represents the task description, that should be solved by developer
  class TestTask < ApplicationRecord
    validates :description, presence: true, length: { minimum: 50 }
    has_many :test_task_assignments, class_name: 'Developer::TestTaskAssignment', foreign_key: 'test_task_id'
  end
end
