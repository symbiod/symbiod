# frozen_string_literal: true

# This model contains a list of possible developer skills
class Skill < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :user_skills
  has_many :users, through: :user_skills
  has_many :developer_test_tasks, class_name: 'Developer::TestTask'
end
