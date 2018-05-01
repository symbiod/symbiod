# frozen_string_literal: true

module Developer
  # Represents the task description, that should be solved by developer
  class TestTask < ApplicationRecord
    validates :description, presence: true, length: { minimum: 50 }
    has_many :test_task_results, class_name: 'Developer::TestTaskResult'
  end
end
