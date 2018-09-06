# frozen_string_literal: true

# == Schema Information
#
# Table name: member_test_task_results
#
#  id         :bigint(8)        not null, primary key
#  link       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Member
  # Represents the result of specific test task, solved by member
  class TestTaskResult < ApplicationRecord
    validates :link, presence: true # TODO: url format?

    has_one :test_task_assignment,
            class_name: 'Member::TestTaskAssignment',
            inverse_of: :test_task_result
  end
end
