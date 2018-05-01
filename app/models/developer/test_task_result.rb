# frozen_string_literal: true

module Developer
  # Represents the result of specific test task, solved by developer
  class TestTaskResult < ApplicationRecord
    validates :link, presence: true # TODO: url format?

    belongs_to :developer, class_name: 'User', foreign_key: 'developer_id'
    belongs_to :test_task, class_name: 'Developer::TestTask'
  end
end
