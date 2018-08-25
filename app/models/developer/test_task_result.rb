# frozen_string_literal: true

module Member
  # Represents the result of specific test task, solved by member
  class TestTaskResult < ApplicationRecord
    validates :link, presence: true # TODO: url format?

    has_one :test_task_assignment,
            class_name: 'Member::TestTaskAssignment',
            inverse_of: :test_task_result
  end
end
