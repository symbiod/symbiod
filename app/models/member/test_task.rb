# frozen_string_literal: true

# == Schema Information
#
# Table name: member_test_tasks
#
#  id          :bigint(8)        not null, primary key
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  title       :string           not null
#  position    :integer
#  state       :string
#  skill_id    :integer
#  role_name   :string
#

module Member
  # Represents the task description, that should be solved by member
  class TestTask < ApplicationRecord
    include AASM

    validates :title, :position, :skill_id, :role_name, presence: true
    validates :description, presence: true, length: { minimum: 50 }

    has_many :test_task_assignments, class_name: 'Member::TestTaskAssignment', foreign_key: 'test_task_id'
    belongs_to :skill

    aasm column: 'state' do
      state :active, initial: true
      state :disabled

      event :activate do
        transitions from: :disabled, to: :active
      end

      event :disable do
        transitions from: :active, to: :disabled
      end
    end
  end
end
