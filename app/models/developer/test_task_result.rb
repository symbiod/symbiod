# frozen_string_literal: true

module Developer
  # Represents the result of specific test task, solved by developer
  class TestTaskResult < ApplicationRecord
    validates :link, presence: true # TODO: url format?

    has_one :test_task_assignment, class_name: 'Developer::TestTaskAssignment'
  end
end
