# frozen_string_literal: true

# It group of skills, that are required for project staffing.
class Stack < ApplicationRecord
  has_many :stack_skills
  has_many :skills, through: :stack_skills

  validates :name, presence: true
  validates :identifier, presence: true, uniqueness: true
end
